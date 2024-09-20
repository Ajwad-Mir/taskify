import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskHelperClasses {
  TaskHelperClasses._();

  static Color getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in-progress':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  static Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String getPriorityCode(int taskPriority) {
    switch (taskPriority) {
      case 1:
        return "Very Low Priority";
      case 2:
        return "Low Priority";
      case 3:
        return "Normal Priority";
      case 4:
        return "High Priority";
      case 5:
        return "Very High Priority";
      default:
        return "";
    }
  }

  static String formatDate(DateTime? date) {
    if (date == null) {
      return "No Deadline";
    }
    return "${date.day}/${date.month}/${date.year}";
  }

  static RxDouble getPercentageCompleted({required String status, required int completedTasksLength, required int allTasksLength}) {
    if (allTasksLength == 0) {
      if(status == 'in-progress') {
        return 0.0.obs;
      }
      return 100.0.obs;
    } else {
      if (completedTasksLength == 0) {
        return 0.0.obs;
      }
      return ((completedTasksLength / allTasksLength) * 100).obs;
    }
  }
}
