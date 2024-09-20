import 'package:get/get.dart';
import 'package:taskify/app/database/tasks_database.dart';
import 'package:taskify/app/models/tasks_model_folder/tasks_model.dart';

class TasksController extends GetxController {
  final isLoading = false.obs;
  final selectedDay = DateTime.now().obs;
  final usersTasks = <TaskModel>[].obs;
  final selectedDayTasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialTasks();
  }

  // Load initial tasks and filter by current date
  Future<void> _loadInitialTasks() async {
    isLoading.value = true;
    await getAllTasks();
    filterTaskBySelectedDate(selectedDay.value, DateTime.now());
    isLoading.value = false;
  }

  // Fetch all tasks from database
  Future<void> getAllTasks() async {
    usersTasks.clear(); // Ensure task list is cleared before re-fetching
    usersTasks.addAll(await TaskDatabase().getAllTasks());
  }

  // Fetch tasks for a specific day
  List<TaskModel> getTasksForDay(DateTime selectedDate) {
    return usersTasks
        .where((element) =>
            element.taskCreatedAt.day == selectedDate.day &&
            element.taskCreatedAt.month == selectedDate.month &&
            element.taskCreatedAt.year == selectedDate.year)
        .toList();
  }

  // Filter tasks by selected date
  void filterTaskBySelectedDate(DateTime calendarSelectedDay, DateTime calendarFocusedDay) {
    selectedDay.value = calendarSelectedDay;
    selectedDayTasks.value = getTasksForDay(selectedDay.value);
  }

  // Delete a task
  Future<void> deleteTask(TaskModel task) async {
    await TaskDatabase().deleteTask(task.taskId);
    usersTasks.remove(task);
    filterTaskBySelectedDate(selectedDay.value, DateTime.now());
  }

  // Update a task
  Future<void> updateTask(TaskModel task) async {
    await TaskDatabase().updateTask(task);
    usersTasks[usersTasks.indexWhere((t) => t.taskId == task.taskId)] = task;
    filterTaskBySelectedDate(selectedDay.value, DateTime.now());
    update();
  }

  Future<void> updateSubTaskStatus({required int taskIndex, required subTaskIndex}) async {
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
}
