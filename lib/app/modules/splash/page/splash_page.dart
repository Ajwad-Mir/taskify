import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskify/app/modules/splash/controller/splash_controller.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/widgets/logo_widget.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      initState: (_) {
        controller.checkIfUserLoggedIn();
      },
      builder: (_) => Scaffold(
        backgroundColor: (Theme.of(context).brightness == Brightness.dark)
            ? AppColors.darkBackgroundColor
            : AppColors.backgroundColor,
        body: const Center(child: LogoWidget()),
      ),
    );
  }

}
