import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/user_model_folder/user_model.dart';
import 'package:taskify/app/modules/tasks/page/tasks_page.dart';
import 'package:taskify/app/services/user_service.dart';
import 'package:taskify/generated/l10n.dart';
import 'package:taskify/global/widgets/custom_loader_widget.dart';

class RegisterController extends GetxController with GetSingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final showPassword = true.obs;
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

  Future<void> registerNewUser() async{
    SmartDialog.showLoading(builder: (context) => CustomLoaderWidget(msg: LocalizationTheme.of(context).registeringUser));
    final user = await UserDatabase().register(fullNameController.text, emailController.text, passwordController.text);
    if(user != null && user != UserModel.empty()) {
      Get.find<UserService>().currentUser.value = user;
      Get.offAll(() => const TasksPage(), transition: Transition.cupertino, duration: 1.seconds);
      SmartDialog.dismiss();
      return;
    }
    SmartDialog.dismiss();
    return;
  }
}