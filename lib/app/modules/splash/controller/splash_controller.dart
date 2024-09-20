import 'package:get/get.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/user_model_folder/user_model.dart';
import 'package:taskify/app/modules/login/page/login_page.dart';
import 'package:taskify/app/modules/tasks/page/tasks_page.dart';
import 'package:taskify/app/services/user_service.dart';

class SplashController extends GetxController {
  void checkIfUserLoggedIn() {
    Future.delayed(2.seconds, () async {
      final user = await UserDatabase().getCurrentUser();
      if (user != null && user != UserModel.empty()) {
        Get.find<UserService>().currentUser.value = user;
        Get.offAll(
          () => const TasksPage(),
          transition: Transition.fadeIn,
          duration: 1.seconds,
          fullscreenDialog: true,
        );
      } else {
        Get.find<UserService>().currentUser.value = UserModel.empty();
        Get.offAll(
          () => const LoginPage(),
          transition: Transition.fadeIn,
          duration: 1.seconds,
          fullscreenDialog: true,
        );
      }
    });
  }
}
