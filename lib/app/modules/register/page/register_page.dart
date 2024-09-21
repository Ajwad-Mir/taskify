import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:taskify/app/modules/login/page/login_page.dart';
import 'package:taskify/app/modules/register/controller/register_controller.dart';
import 'package:taskify/generated/assets.dart';
import 'package:taskify/generated/l10n.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';
import 'package:taskify/global/widgets/custom_text_field_widget.dart';
import 'package:taskify/global/widgets/logo_widget.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (_) => Scaffold(
        backgroundColor: (Theme.of(context).brightness == Brightness.dark) ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const LogoWidget(),
                    30.verticalSpace,
                    _buildForm(context),
                    20.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationTheme.of(context).register,
              style: AppTextStyles.semiBold.copyWith(
                fontSize: 36.sp,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              ),
            ),
            20.verticalSpace,
            CustomizedTextFormField(
              controller: controller.fullNameController,
              fieldType: TextInputType.name,
              style: AppTextStyles.medium.copyWith(
                fontSize: 16.sp,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
              ),
              hintText: LocalizationTheme.of(context).fullName,
              hintStyle: AppTextStyles.normal.copyWith(
                fontSize: 16.sp,
                color:
                    Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
              ),
              validator: (val) {
                if (val.toString().isEmpty) {
                  return LocalizationTheme.of(context).pleaseEnterFullName;
                }
                return null;
              },
              fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
              prefixIcon: Assets.svgLoginPerson,
              prefixIconColor: const Color(0xFF7B6F72),
            ),
            20.verticalSpace,
            CustomizedTextFormField(
              controller: controller.emailController,
              fieldType: TextInputType.emailAddress,
              style: AppTextStyles.medium.copyWith(
                fontSize: 16.sp,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
              ),
              hintText: LocalizationTheme.of(context).emailAddress,
              hintStyle: AppTextStyles.normal.copyWith(
                fontSize: 16.sp,
                color:
                    Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
              ),
              validator: (val) {
                if (val.toString().isEmpty) {
                  return LocalizationTheme.of(context).pleaseEnterEmailAddress;
                }
                return null;
              },
              fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
              prefixIcon: Assets.svgLoginEmail,
              prefixIconColor: const Color(0xFF7B6F72),
            ),
            20.verticalSpace,
            Obx(
              () => CustomizedTextFormField(
                controller: controller.passwordController,
                fieldType: TextInputType.visiblePassword,
                style: AppTextStyles.medium.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
                ),
                obscureText: controller.showPassword.value,
                hintText: LocalizationTheme.of(context).password,
                hintStyle: AppTextStyles.normal.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextColor.withOpacity(0.4)
                      : AppColors.textColor.withOpacity(0.4),
                ),
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return LocalizationTheme.of(context).pleaseEnterPassword;
                  } else if (val.toString().length <= 6) {
                    return LocalizationTheme.of(context).passwordLengthMustBeGreaterThanSixCharacters;
                  } else if (val.toString() != controller.confirmPasswordController.text) {
                    return LocalizationTheme.of(context).bothPasswordsMustBeSame;
                  }
                  return null;
                },
                suffixIcon: controller.showPassword.isFalse ? Assets.svgShowPassword : Assets.svgHidePassword,
                onSuffixIconClicked: () {
                  controller.showPassword.value = !controller.showPassword.value;
                },
                fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
                prefixIcon: Assets.svgLoginPassword,
                prefixIconColor: const Color(0xFF7B6F72),
              ),
            ),
            20.verticalSpace,
            Obx(
              () => CustomizedTextFormField(
                controller: controller.confirmPasswordController,
                fieldType: TextInputType.visiblePassword,
                style: AppTextStyles.medium.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
                ),
                obscureText: controller.showConfirmPassword.value,
                hintText: LocalizationTheme.of(context).confirmPassword,
                hintStyle: AppTextStyles.normal.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextColor.withOpacity(0.4)
                      : AppColors.textColor.withOpacity(0.4),
                ),
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return LocalizationTheme.of(context).pleaseEnterPassword;
                  } else if (val.toString().length <= 6) {
                    return LocalizationTheme.of(context).passwordLengthMustBeGreaterThanSixCharacters;
                  } else if (val.toString() != controller.passwordController.text) {
                    return LocalizationTheme.of(context).bothPasswordsMustBeSame;
                  }
                  return null;
                },
                suffixIcon: controller.showConfirmPassword.isFalse ? Assets.svgShowPassword : Assets.svgHidePassword,
                onSuffixIconClicked: () {
                  controller.showConfirmPassword.value = !controller.showConfirmPassword.value;
                },
                fillColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
                prefixIcon: Assets.svgLoginPassword,
                prefixIconColor: const Color(0xFF7B6F72),
              ),
            ),
            20.verticalSpace,
            _buildRegisterButton(context),
            30.verticalSpace,
            _buildLoginOption(context),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () async {
        if (controller.formKey.currentState!.validate()) {
          controller.registerNewUser();
        }
      },
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: AppColors.primaryGradient,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        alignment: Alignment.center,
        child: Text(
          LocalizationTheme.of(context).register,
          style: AppTextStyles.normal.copyWith(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          LocalizationTheme.of(context).alreadyHaveAnAccount,
          style: AppTextStyles.medium.copyWith(
            fontSize: 18.sp,
            color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.5) : AppColors.textColor.withOpacity(0.5),
          ),
        ),
        CupertinoButton(
          onPressed: () {
            Get.off(
              () => const LoginPage(),
              transition: Transition.fadeIn,
              fullscreenDialog: true,
              duration: 1.seconds,
            );
          },
          minSize: 0,
          padding: EdgeInsets.zero,
          child: Text(
            LocalizationTheme.of(context).login,
            style: AppTextStyles.bold.copyWith(
              fontSize: 18.sp,
              decoration: TextDecoration.underline,
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
            ),
          ),
        )
      ],
    );
  }
}
