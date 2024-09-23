import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taskify/app/modules/profile/controller/profile_controller.dart';
import 'package:taskify/app/services/localization_service.dart';
import 'package:taskify/generated/assets.dart';
import 'package:taskify/generated/l10n.dart';
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
        key: ValueKey(Get.find<LocalizationService>().locale.languageCode),
        backgroundColor: (Theme.of(context).brightness == Brightness.dark) ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            CupertinoButton(
              onPressed: () async {
                final currentLocale = Get.find<LocalizationService>().locale.languageCode;
                final newLocale = currentLocale == 'en' ? 'ar' : 'en';

                // Start the fade-out animation
                controller.animationController.forward().then((_) {
                  Get.find<LocalizationService>().changeLocale(newLocale);
                  controller.animationController.reverse();
                });
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: SvgPicture.asset(
                Assets.svgEnglishToArabic,
                colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, BlendMode.srcIn),
                width: 30.w,
                height: 30.w,
              ),
            ),
            20.horizontalSpace,
          ],
        ),
        body: FadeTransition(
          opacity: controller.animation,
          child: SizedBox(
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
              LocalizationTheme.of(context).update,
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
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
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
            Obx(
              () => CustomizedTextFormField(
                controller: controller.newPasswordController,
                fieldType: TextInputType.visiblePassword,
                style: AppTextStyles.medium.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
                ),
                obscureText: controller.showNewPassword.value,
                hintText: LocalizationTheme.of(context).password,
                hintStyle: AppTextStyles.normal.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
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
                hintText: LocalizationTheme.of(context).confirmPassword,
                hintStyle: AppTextStyles.normal.copyWith(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor.withOpacity(0.4) : AppColors.textColor.withOpacity(0.4),
                ),
                validator: (val) {
                  if (val.toString().isEmpty) {
                    return LocalizationTheme.of(context).pleaseEnterPassword;
                  } else if (val.toString().length <= 6) {
                    return LocalizationTheme.of(context).passwordLengthMustBeGreaterThanSixCharacters;
                  } else if (val.toString() != controller.newPasswordController.text) {
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
          LocalizationTheme.of(context).update,
          style: AppTextStyles.normal.copyWith(
            fontSize: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
