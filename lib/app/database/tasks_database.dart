import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:taskify/app/models/tasks_model_folder/tasks_model.dart';
import 'package:taskify/global/helper/connection_helper.dart';

class TaskDatabase {
  static final TaskDatabase _instance = TaskDatabase._internal();

  factory TaskDatabase() => _instance;

  TaskDatabase._internal();

  Future<void> init() async {
    await syncFirestoreToLocal(); // Sync Firestore to local on initialization if online
    _setupConnectivityListener();
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        syncTasks();
      }
    });
  }

  // Open the Hive box for tasks
  Future<Box<TaskModel>> _openBox() async {
    final userID = await GetStorage().read('currentUserID');
    return await Hive.openBox<TaskModel>('users_${userID}_tasksBox');
  }

  // Open the Hive box for deleted task IDs
  Future<Box<String>> _openDeletedTasksBox() async {
    final userID = await GetStorage().read('currentUserID');
    return await Hive.openBox<String>('users_${userID}_deletedTasksBox');
  }

  // Generate a custom UID for offline task creation (always 28 characters)
  String _generateCustomUid(int length) {
    const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) => characters[Random.secure().nextInt(characters.length)]).join();
  }

  // Create a new task (local and Firestore if online)
  Future<void> createTask(TaskModel task) async {
    final isOffline = await ConnectionHelper.hasNoConnectivity();
    final box = await _openBox();

    // If creating offline, generate a custom ID
    if (isOffline) {
      task = task.copyWith(taskId: _generateCustomUid(28));
    }

    // Add task to Hive
    await box.put(task.taskId, task);

    // Sync with Firestore if online
    if (!isOffline) {
      await _syncTaskToFirestore(task);
    }
  }

// Read all tasks from Firebase if online, or Hive (local storage) if offline
  Future<List<TaskModel>> getAllTasks() async {
    final isOffline = await ConnectionHelper.hasNoConnectivity();
    final box = await _openBox();

    if (isOffline) {
      // Retrieve all tasks from Hive (local storage)
      final tasks = box.values.toList();
      return tasks;
    } else {
      // Sync local Hive tasks to Firebase before fetching from Firebase
      await syncTasks();

      // Retrieve all tasks from Firebase (online)
      final userId = await GetStorage().read('currentUserID');
      if (userId == null || userId.isEmpty) {
        return [];
      }

      final querySnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks').get();

      final tasks = querySnapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.data());
      }).toList();

      // Optionally, you can also sync the fetched tasks back to Hive here if needed.
      return tasks;
    }
  }

  // Update a task (local and Firestore if online)
  Future<void> updateTask(TaskModel updatedTask) async {
    final box = await _openBox();

    // Update the task in Hive (local storage)
    await box.put(updatedTask.taskId, updatedTask);

    // If the user is online, sync the updated task to Firestore
    final isOffline = await ConnectionHelper.hasNoConnectivity();
    if (!isOffline) {
      await _syncTaskToFirestore(updatedTask, updateTaskId: true);
    }
  }

  // Delete a task (local and Firestore if online)
  Future<void> deleteTask(String taskId) async {
    final box = await _openBox();
    final deletedTasksBox = await _openDeletedTasksBox();

    // Delete the task from Hive (local storage)
    await box.delete(taskId);

    // If the user is online, delete the task from Firestore
    final isOffline = await ConnectionHelper.hasNoConnectivity();
    if (!isOffline) {
      await _deleteTaskFromFirestore(taskId);
    } else {
      // If offline, add the taskId to the deleted tasks box
      await deletedTasksBox.add(taskId);
    }
  }

  // Sync local tasks to Firestore when the user is online
  Future<void> syncTasks() async {
    final box = await _openBox();
    final deletedTasksBox = await _openDeletedTasksBox();
    final tasks = box.values.toList();

    final isOffline = await ConnectionHelper.hasNoConnectivity();
    if (!isOffline) {
      // Sync deleted tasks
      for (var taskId in deletedTasksBox.values) {
        await _deleteTaskFromFirestore(taskId);
      }
      await deletedTasksBox.clear();

      // Sync existing tasks
      for (var task in tasks) {
        if (task.taskId.length == 28) {
          // Task was created offline, so sync and update taskId
          await _syncTaskToFirestore(task, updateTaskId: true);
        } else {
          // Task exists with a valid taskId, sync as usual
          final existsInFirestore = await _taskExistsInFirestore(task.taskId);
          if (!existsInFirestore) {
            await _syncTaskToFirestore(task);
          }
        }
      }
    }
  }

  // Sync Firestore tasks to Hive (when the user becomes online)
  Future<void> syncFirestoreToLocal() async {
    try {
      final isOffline = await ConnectionHelper.hasNoConnectivity();
      if (!isOffline) {
        final userId = await GetStorage().read('currentUserID');
        if (userId == null || userId.isEmpty) {
          return;
        }

        final querySnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks').get();
        final box = await _openBox();

        // Get all local task IDs
        final localTaskIds = box.keys.cast<String>().toSet();

        // Process Firestore tasks
        for (var doc in querySnapshot.docs) {
          final task = TaskModel.fromMap(doc.data());
          if (task.taskId.isNotEmpty) {
            if (localTaskIds.contains(task.taskId)) {
              // Task exists locally, update it
              await box.put(task.taskId, task);
              localTaskIds.remove(task.taskId);
            }
          } else {
            // Task doesn't have a valid taskId, delete it from Firestore
            await _deleteTaskFromFirestore(doc.id);
          }
        }

        // Any remaining localTaskIds are new tasks created offline
        for (var taskId in localTaskIds) {
          final task = box.get(taskId);
          if (task != null && task.taskId.isNotEmpty) {
            await _syncTaskToFirestore(task, updateTaskId: true);
          } else {
            // Remove local task with invalid taskId
            await box.delete(taskId);
          }
        }
      }
    } catch (e) {
      // Handle the error appropriately
    }
  }

  Future<void> _syncTaskToFirestore(TaskModel task, {bool updateTaskId = false}) async {
    final userId = await GetStorage().read('currentUserID');

    if (userId == null || userId.isEmpty) {
      return;
    }

    if (updateTaskId && task.taskId.isEmpty) {
      return;
    }

    try {
      if (!updateTaskId) {
        // Add to Firestore with a new document ID and update taskId in Hive
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks').add(task.toMap()).then((val) async {
          await FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks').doc(val.id).update({'taskId': val.id});
          // Update the task with the new taskId in Hive
          final box = await _openBox();
          task = task.copyWith(taskId: val.id);
          await box.put(task.taskId, task);
        });
      } else {
        // Add or update the task in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks').doc(task.taskId).set(task.toMap());
      }
    } catch (e) {
      // Handle the error appropriately
    }
  }

  // Helper method to delete a task from Firestore
  Future<void> _deleteTaskFromFirestore(String taskId) async {
    final userId = await GetStorage().read('currentUserID');
    await FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks').doc(taskId).delete();
  }

  // Helper method to check if a task exists in Firestore
  Future<bool> _taskExistsInFirestore(String taskId) async {
    if (taskId.isEmpty) {
      throw ArgumentError('taskId cannot be empty');
    }

    final userId = await GetStorage().read('currentUserID');
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).collection('tasks').doc(taskId).get();

    return doc.exists;
  }
}
