import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/user_model_folder/user_model.dart';
import 'package:taskify/app/modules/tasks/page/tasks_page.dart';
import 'package:taskify/app/services/user_service.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final showPassword = true.obs;
  final confirmPasswordController = TextEditingController();
  final showConfirmPassword = true.obs;

  Future<void> registerNewUser() async{
    final user = await UserDatabase().register(fullNameController.text, emailController.text, passwordController.text);
    if(user != null && user != UserModel.empty()) {
      Get.find<UserService>().currentUser.value = user;
      Get.offAll(() => const TasksPage(), transition: Transition.cupertino, duration: 1.seconds);
    }
  }
}