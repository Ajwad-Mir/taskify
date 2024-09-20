import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:taskify/app/services/user_service.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final showNewPassword = true.obs;
  final confirmPasswordController = TextEditingController();
  final showConfirmPassword = true.obs;

  Future<void> updateExistingUser() async {
    final result = await Get.find<UserService>().updateUser(emailController.text, fullNameController.text, newPasswordController.text);
    if (result != Get.find<UserService>().currentUser.value) {
      Get.find<UserService>().currentUser.value = result;
      Get.back();

    } else {
      SmartDialog.showToast('User Failed To Update');
    }
  }
}
