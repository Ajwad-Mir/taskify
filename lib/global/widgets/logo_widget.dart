import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taskify/generated/assets.dart';
import 'package:taskify/generated/l10n.dart';
import 'package:taskify/global/colors/colors.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Hero(
        tag: 'tag-logo',
        child: Material(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackgroundColor : AppColors.backgroundColor,
          type: MaterialType.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLogoImage(context),
              5.verticalSpace,
              _buildLogoText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoImage(BuildContext context) {
    return Container(
      width: 150.w,
      height: 150.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black,
          width: 2.5.w,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.w,vertical: 25.h),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        Assets.svgLogo,
        fit: BoxFit.contain
      ),
    );
  }

  Widget _buildLogoText(BuildContext context) {
    return Text(
      LocalizationTheme.of(context).appName,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextColor : AppColors.textColor,
        fontFamily: Assets.fontsBodoniModaSCVariableFont,
        fontSize: 36.sp,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        letterSpacing: -2,
      ),
    );
  }
}
