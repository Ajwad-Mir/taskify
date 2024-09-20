import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'tasks_model.g.dart'; // Required for Hive type adapter

@HiveType(typeId: 1) // Hive type annotation
class TaskModel {
  @HiveField(0)
  final String taskId;

  @HiveField(1)
  String taskTitle;

  @HiveField(2)
  String? taskDescription;

  @HiveField(3)
  String taskStatus; // e.g. "in-progress", "completed"

  @HiveField(4)
  int taskPriority; // e.g. "low", "medium", "high"

  @HiveField(5)
  DateTime? taskDueDate;

  @HiveField(6)
  DateTime taskCreatedAt;

  @HiveField(7)
  DateTime taskUpdatedAt;

  @HiveField(8)
  List<SubTaskModel> taskSubtasks; // Changed from List<SubTaskModel>? to List<SubTaskModel>

  @HiveField(9)
  String taskNotes; // New field

  TaskModel({
    required this.taskId,
    required this.taskTitle,
    this.taskDescription,
    required this.taskStatus,
    required this.taskPriority,
    this.taskDueDate,
    required this.taskCreatedAt,
    required this.taskUpdatedAt,
    required this.taskSubtasks, // Changed to required
    required this.taskNotes, // New required field
  });

  // Example factory constructor for creating an empty task
  factory TaskModel.empty() {
    return TaskModel(
      taskId: '',
      taskTitle: '',
      taskStatus: 'pending',
      taskPriority: 1,
      taskCreatedAt: DateTime.now(),
      taskUpdatedAt: DateTime.now(),
      taskSubtasks: [],
      taskNotes: '',
    );
  }

  // Example factory constructor for creating an empty task
  factory TaskModel.createNewTask({
    required String taskTitle,
    required String taskDescription,
    required int taskPriority,
    required DateTime? taskDueDate,
    required List<SubTaskModel> taskSubtasks, // Changed to required
    required String taskNotes,
  }) {
    return TaskModel(
      taskId: '',
      taskTitle: taskTitle,
      taskStatus: 'pending',
      taskDescription: taskDescription,
      taskPriority: taskPriority,
      taskCreatedAt: DateTime.now(),
      taskUpdatedAt: DateTime.now(),
      taskDueDate: taskDueDate == DateTime.now() ? null : taskDueDate,
      taskSubtasks: taskSubtasks,
      taskNotes: taskNotes,
    );
  }

  // Convert Map to TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'],
      taskTitle: map['taskTitle'],
      taskDescription: map['taskDescription'],
      taskStatus: map['taskStatus'],
      taskPriority: map['taskPriority'],
      taskDueDate: map['taskDueDate'] != null ? (map['taskDueDate'] as Timestamp).toDate() : null,
      taskCreatedAt: (map['taskCreatedAt'] as Timestamp).toDate(),
      taskUpdatedAt: (map['taskUpdatedAt'] as Timestamp).toDate(),
      taskSubtasks: (map['taskSubtasks'] as List<dynamic>).map((subtask) => SubTaskModel.fromMap(subtask)).toList(),
      taskNotes: map['taskNotes'], // Extract taskNotes from the map
    );
  }

  // Convert TaskModel to Map (useful for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'taskStatus': taskStatus,
      'taskPriority': taskPriority,
      'taskDueDate': taskDueDate != null ? Timestamp.fromDate(taskDueDate!) : null,
      'taskCreatedAt': Timestamp.fromDate(taskCreatedAt),
      'taskUpdatedAt': Timestamp.fromDate(taskUpdatedAt),
      'taskSubtasks': taskSubtasks.map((subtask) => subtask.toMap()).toList(),
      'taskNotes': taskNotes, // Include taskNotes in the map
    };
  }

  List<SubTaskModel> updateAllSubtasks(bool newStatus) {
    return taskSubtasks.map((subtask) => subtask.copyWith(subTaskStatus: newStatus)).toList();
  }

  TaskModel copyWith({
    String? taskId,
    String? taskTitle,
    String? taskDescription,
    String? taskStatus,
    int? taskPriority,
    DateTime? taskDueDate,
    DateTime? taskCreatedAt,
    DateTime? taskUpdatedAt,
    List<SubTaskModel>? taskSubtasks,
    String? taskNotes,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      taskTitle: taskTitle ?? this.taskTitle,
      taskDescription: taskDescription ?? this.taskDescription,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: taskPriority ?? this.taskPriority,
      taskDueDate: taskDueDate ?? this.taskDueDate,
      taskCreatedAt: taskCreatedAt ?? this.taskCreatedAt,
      taskUpdatedAt: taskUpdatedAt ?? this.taskUpdatedAt,
      taskSubtasks: taskSubtasks ?? this.taskSubtasks,
      taskNotes: taskNotes ?? this.taskNotes,
    );
  }

  // Convert Firestore DocumentSnapshot to TaskModel
  factory TaskModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TaskModel(
      taskId: data['taskId'],
      taskTitle: data['taskTitle'],
      taskDescription: data['taskDescription'],
      taskStatus: data['taskStatus'],
      taskPriority: data['taskPriority'],
      taskDueDate: data['taskDueDate'] != null ? (data['taskDueDate'] as Timestamp).toDate() : null,
      taskCreatedAt: (data['taskCreatedAt'] as Timestamp).toDate(),
      taskUpdatedAt: (data['taskUpdatedAt'] as Timestamp).toDate(),
      taskSubtasks: (data['taskSubtasks'] as List<dynamic>).map((subtask) => SubTaskModel.fromMap(subtask)).toList(),
      taskNotes: data['taskNotes'],
    );
  }
}

@HiveType(typeId: 2) // Hive type annotation for subtask
class SubTaskModel {
  @HiveField(0)
  final String subTaskTitle;

  @HiveField(1)
  final bool subTaskStatus;

  SubTaskModel({
    required this.subTaskTitle,
    required this.subTaskStatus,
  });

  // Convert SubTaskModel to Map (for JSON)
  Map<String, dynamic> toMap() {
    return {
      'subTaskTitle': subTaskTitle,
      'subTaskStatus': subTaskStatus,
    };
  }

  // Convert Map to SubTaskModel
  factory SubTaskModel.fromMap(Map<String, dynamic> map) {
    return SubTaskModel(
      subTaskTitle: map['subTaskTitle'],
      subTaskStatus: map['subTaskStatus'],
    );
  }

  SubTaskModel copyWith({
    String? subTaskTitle,
    bool? subTaskStatus,
  }) {
    return SubTaskModel(
      subTaskTitle: subTaskTitle ?? this.subTaskTitle,
      subTaskStatus: subTaskStatus ?? this.subTaskStatus,
    );
  }
}
