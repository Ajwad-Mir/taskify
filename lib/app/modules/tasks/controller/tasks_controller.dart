import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/app/database/tasks_database.dart';
import 'package:taskify/app/models/tasks_model_folder/tasks_model.dart';

class TasksController extends GetxController with GetSingleTickerProviderStateMixin {
  final isLoading = false.obs;
  final selectedDay = DateTime.now().obs;
  final usersTasks = <TaskModel>[].obs;
  final selectedDayTasks = <TaskModel>[].obs;
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    );

    animation = Tween<double>(begin: 1.0, end: 0.0).animate(animationController);
    _loadInitialTasks();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialTasks() async {
    isLoading.value = true;
    await getAllTasks();
    filterTaskBySelectedDate(selectedDay.value, DateTime.now());
    isLoading.value = false;
  }

  Future<void> getAllTasks() async {
    usersTasks.clear();
    usersTasks.addAll(await TaskDatabase().getAllTasks());
  }

  List<TaskModel> getTasksForDay(DateTime selectedDate) {
    return usersTasks
        .where((element) => element.taskCreatedAt.day == selectedDate.day && element.taskCreatedAt.month == selectedDate.month && element.taskCreatedAt.year == selectedDate.year)
        .toList();
  }

  void filterTaskBySelectedDate(DateTime calendarSelectedDay, DateTime calendarFocusedDay) {
    selectedDay.value = calendarSelectedDay;
    selectedDayTasks.value = getTasksForDay(selectedDay.value);
  }

  Future<void> deleteTask(TaskModel task) async {
    await TaskDatabase().deleteTask(task.taskId);
    usersTasks.remove(task);
    filterTaskBySelectedDate(selectedDay.value, DateTime.now());
  }

  Future<void> updateTask(TaskModel task) async {
    await TaskDatabase().updateTask(task);
    usersTasks[usersTasks.indexWhere((t) => t.taskId == task.taskId)] = task;
    filterTaskBySelectedDate(selectedDay.value, DateTime.now());
    update();
  }

  Future<void> updateSubTaskStatus({required int taskIndex, required int subTaskIndex}) async {
    var subTasks = selectedDayTasks[taskIndex].taskSubtasks;
    subTasks[subTaskIndex] = subTasks[subTaskIndex].copyWith(subTaskStatus: !subTasks[subTaskIndex].subTaskStatus);
    selectedDayTasks[taskIndex] = selectedDayTasks[taskIndex].copyWith(
      taskSubtasks: subTasks,
      taskUpdatedAt: DateTime.now(),
      taskStatus: selectedDayTasks[taskIndex].taskStatus == 'completed'
          ? 'in-progress'
          : subTasks.every((element) => element.subTaskStatus == true) == true
              ? "completed"
              : "in-progress",
    );
    await updateTask(selectedDayTasks[taskIndex]);
  }

  Future<void> deleteSubTask({required int taskIndex, required SubTaskModel selectedSubTask}) async {
    var subTasks = selectedDayTasks[taskIndex].taskSubtasks;
    subTasks.remove(selectedSubTask);
    selectedDayTasks[taskIndex] = selectedDayTasks[taskIndex].copyWith(
      taskSubtasks: subTasks,
      taskUpdatedAt: DateTime.now(),
    );
    await updateTask(selectedDayTasks[taskIndex]);
  }
}
