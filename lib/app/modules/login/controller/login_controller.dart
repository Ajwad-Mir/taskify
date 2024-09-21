import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taskify/app/database/tasks_database.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/user_model_folder/user_model.dart';
import 'package:taskify/app/modules/tasks/page/tasks_page.dart';
import 'package:taskify/app/services/user_service.dart';
import 'package:taskify/global/helper/connection_helper.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final showPassword = true.obs;
  final isSyncing = false.obs;

  Future<void> loginExistingUser() async {
    final user = await UserDatabase().login(emailController.text, passwordController.text);
    if (user != null && user != UserModel.empty()) {
      Get.find<UserService>().currentUser.value = user;

      
      bool isOnline = !await ConnectionHelper.hasNoConnectivity();

      if (isOnline) {
        await TaskDatabase().syncTasks();
      }

      Get.offAll(() => const TasksPage(), transition: Transition.cupertino, duration: 1.seconds);
    }
  }

}