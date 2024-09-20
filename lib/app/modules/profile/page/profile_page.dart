import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:taskify/app/modules/profile/controller/profile_controller.dart';
import 'package:taskify/generated/assets.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';
import 'package:taskify/global/widgets/custom_text_field_widget.dart';
import 'package:taskify/global/widgets/logo_widget.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
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
              "Update",
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
              hintText: "Full Name",
              hintStyle: AppTextStyles.normal.copyWith(
                fontSize: 16.sp,
                color:
                    Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
              ),
              validator: (val) {
                if (val.toString().isEmpty) {
                  return "Please enter full name";
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
              hintText: "Email Address",
              hintStyle: AppTextStyles.normal.copyWith(
                fontSize: 16.sp,
                color:
                    Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
              ),
              validator: (val) {
                if (val.toString().isEmpty) {
                  return "Please enter email address";
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
                controller: controller.newPasswordController,
                fieldType: TextInputType.visiblePassword,
                style: AppTextStyles.medium.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
                ),
                obscureText: controller.showNewPassword.value,
                hintText: "Password",
                hintStyle: AppTextStyles.normal.copyWith(
                  fontSize: 16.sp,
                  color:
                      Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
                ),
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return "Please enter password";
                  } else if (val.toString().length <= 6) {
                    return "Password length must be greater than 6 characters";
                  } else if (val.toString() != controller.confirmPasswordController.text) {
                    return "Both Passwords must be same";
                  }
                  return null;
                },
                suffixIcon: controller.showNewPassword.isFalse ? Assets.svgShowPassword : Assets.svgHidePassword,
                onSuffixIconClicked: () {
                  controller.showNewPassword.value = !controller.showNewPassword.value;
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
                hintText: "Confirm Password",
                hintStyle: AppTextStyles.normal.copyWith(
                  fontSize: 16.sp,
                  color:
                      Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
                ),
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return "Please enter password";
                  } else if (val.toString().length <= 6) {
                    return "Password length must be greater than 6 characters";
                  } else if (val.toString() != controller.newPasswordController.text) {
                    return "Both Passwords must be same";
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
            _buildUpdateButton(context),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton(BuildContext context) {
    return CupertinoButton(
      onPressed: () async {
        await controller.updateExistingUser();
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
          "Update",
          style: AppTextStyles.normal.copyWith(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
