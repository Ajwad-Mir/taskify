import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:taskify/app/modules/login/page/login_page.dart';
import 'package:taskify/app/services/user_service.dart';
import 'package:taskify/generated/l10n.dart';
import 'package:taskify/global/widgets/custom_loader_widget.dart';

class ProfileController extends GetxController with GetSingleTickerProviderStateMixin{
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final newPasswordController = TextEditingController();
  final showNewPassword = true.obs;
  final confirmPasswordController = TextEditingController();
  final showConfirmPassword = true.obs;
  late final AnimationController animationController;
  late final Animation<double> animation;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    animation = Tween<double>(begin: 1.0, end: 0.0).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> updateExistingUser() async {
    SmartDialog.showLoading(builder: (context) => CustomLoaderWidget(msg: LocalizationTheme.of(context).updatingProfile));
    final result = await Get.find<UserService>().updateUser(fullNameController.text, newPasswordController.text);
    if (result != Get.find<UserService>().currentUser.value) {
      Get.find<UserService>().currentUser.value = result;
      await GetStorage().write('currentUserID', null);
      SmartDialog.dismiss();
      Get.offAll(
        () => const LoginPage(),
        transition: Transition.cupertino,
      );
      return;
    } else {
      SmartDialog.dismiss();
      SmartDialog.showToast('User Failed To Update');
    }
  }
}
