import 'package:get/get.dart';
import 'package:taskify/app/database/user_database.dart';
import 'package:taskify/app/models/user_model_folder/user_model.dart';

class UserService extends GetxService{

  final Rx<UserModel> currentUser = UserModel.empty().obs;

  Future<UserModel> updateUser(String? email, String? fullName, String? password) async{

    final updatedUser = Get.find<UserService>().currentUser.value.copyWith(
      email: (email.toString().isEmpty || email.toString() == Get.find<UserService>().currentUser.value.email)
          ? Get.find<UserService>().currentUser.value.email
          : email.toString(),
      fullName: (fullName.toString().isEmpty || fullName.toString() == Get.find<UserService>().currentUser.value.fullName)
          ? Get.find<UserService>().currentUser.value.fullName
          : fullName.toString(),
      password: (password.toString().isEmpty || password.toString() == Get.find<UserService>().currentUser.value.password)
          ? Get.find<UserService>().currentUser.value.password
          : password.toString(),
    );
    final result = await UserDatabase().updateUser(updatingUser: updatedUser);
    return result ?? currentUser.value;
  }
}