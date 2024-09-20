import 'package:get/get.dart';
import 'package:taskify/app/modules/login/controller/login_controller.dart';
import 'package:taskify/app/modules/profile/controller/profile_controller.dart';
import 'package:taskify/app/modules/register/controller/register_controller.dart';
import 'package:taskify/app/modules/splash/controller/splash_controller.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_controller.dart';
import 'package:taskify/app/modules/tasks/controller/tasks_details_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
    Get.lazyPut(() => LoginController(),fenix: true);
    Get.lazyPut(() => RegisterController(),fenix: true);
    Get.lazyPut(() => TasksController(),fenix: true);
    Get.lazyPut(() => TasksDetailsController(),fenix: true);
    Get.lazyPut(() => ProfileController(),fenix: true);
  }
}