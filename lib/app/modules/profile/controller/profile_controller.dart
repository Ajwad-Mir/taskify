import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskify/app/modules/login/page/login_page.dart';
import 'package:taskify/app/services/user_service.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final newPasswordController = TextEditingController();
  final showNewPassword = true.obs;
  final confirmPasswordController = TextEditingController();
  final showConfirmPassword = true.obs;

  Future<void> updateExistingUser() async {
    final result = await Get.find<UserService>().updateUser(fullNameController.text, newPasswordController.text);
    if (result != Get.find<UserService>().currentUser.value) {
      Get.find<UserService>().currentUser.value = result;
      await GetStorage().write('currentUserID', null);
      Get.offAll(
        () => const LoginPage(),
        transition: Transition.cupertino,
      );
      return;
    } else {
      SmartDialog.showToast('User Failed To Update');
    }
  }
}
