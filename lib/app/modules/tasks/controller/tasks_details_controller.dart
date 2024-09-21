import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:taskify/app/database/tasks_database.dart';
import 'package:taskify/app/models/tasks_model_folder/tasks_model.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_controller.dart';
import 'package:taskify/app/services/localization_service.dart';
import 'package:taskify/generated/l10n.dart';
import 'package:taskify/global/widgets/custom_loader_widget.dart';

class TasksDetailsController extends GetxController {
  final selectedTask = TaskModel.empty().obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();
  final subtaskControllers = <TextEditingController>[].obs;
  final priorityList = [
    LocalizationTheme.current.veryLow,
    LocalizationTheme.current.low,
    LocalizationTheme.current.normal,
    LocalizationTheme.current.high,
    LocalizationTheme.current.veryHigh,
  ];
  final selectedPriority = LocalizationTheme.current.normal.obs;
  var descriptionLength = 0.obs;
  final selectedDueDate = Rxn<DateTime>();
  final isUpdateMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    descriptionController.addListener(() {
      descriptionLength.value = descriptionController.text.replaceAll('\n', '').length;
    });
  }

  void setupDateForUpdate(TaskModel task) {
    titleController.text = task.taskTitle;
    descriptionController.text = task.taskDescription ?? '';
    selectedPriority.value = priorityList.elementAt(task.taskPriority - 1);
    notesController.text = task.taskNotes;
    selectedDueDate.value = task.taskDueDate;
    for (var element in task.taskSubtasks) {
      subtaskControllers.add(TextEditingController(text: element.subTaskTitle));
    }
  }

  void addSubtask() {
    subtaskControllers.add(TextEditingController());
  }

  void removeSubtask(int index) {
    subtaskControllers.removeAt(index);
  }

  Future<void> selectDueDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      locale: Get.find<LocalizationService>().locale,
      initialDate: selectedDueDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100, 12, 31),
    );

    if (picked != selectedDueDate.value) {
      selectedDueDate.value = picked;
    }
  }

  Future<void> createTask() async {
    SmartDialog.showLoading(
      builder: (context) => CustomLoaderWidget(
        msg: LocalizationTheme.of(context).creatingTask,
      ),
    );

    final newTask = TaskModel.createNewTask(
      taskTitle: titleController.text,
      taskDescription: descriptionController.text.isEmpty ? '' : descriptionController.text,
      taskPriority: priorityList.indexOf(selectedPriority.value) + 1,
      taskDueDate: selectedDueDate.value ?? DateTime.now(),
      taskSubtasks: subtaskControllers.map((controller) => SubTaskModel(subTaskTitle: controller.text, subTaskStatus: false)).toList(),
      taskNotes: notesController.text,
    );

    await TaskDatabase().createTask(newTask);

    final tasksController = Get.find<TasksController>();
    await tasksController.getAllTasks();
    tasksController.filterTaskBySelectedDate(tasksController.selectedDay.value, DateTime.now());

    SmartDialog.dismiss();
    Get.back();
  }

  Future<void> updateTask() async {
    SmartDialog.showLoading(
      builder: (context) => CustomLoaderWidget(
        msg: LocalizationTheme.of(context).updatingTask,
      ),
    );

    final updatedTask = selectedTask.value.copyWith(
      taskTitle: titleController.text,
      taskDescription: descriptionController.text,
      taskPriority: priorityList.indexOf(selectedPriority.value) + 1,
      taskDueDate: selectedDueDate.value,
      taskSubtasks: subtaskControllers.map((controller) => SubTaskModel(subTaskTitle: controller.text, subTaskStatus: false)).toList(),
      taskNotes: notesController.text,
      taskUpdatedAt: DateTime.now(),
    );

    await TaskDatabase().updateTask(updatedTask);

    final tasksController = Get.find<TasksController>();
    await tasksController.getAllTasks();
    tasksController.filterTaskBySelectedDate(tasksController.selectedDay.value, DateTime.now());
    clearData();
    SmartDialog.dismiss();
    Get.back();
  }

  void clearData() {
    titleController.clear();
    descriptionController.clear();
    selectedPriority.value = LocalizationTheme.current.normal;
    notesController.clear();
    selectedDueDate.value = null;
    subtaskControllers.clear();
    selectedTask.value = TaskModel.empty();
    isUpdateMode.value = false;
  }
}
