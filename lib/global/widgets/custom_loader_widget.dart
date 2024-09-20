import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskify/global/colors/colors.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';

class CustomLoaderWidget extends StatelessWidget {
  final String msg;
  const CustomLoaderWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r), color: Colors.black.withOpacity(0.8)),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          20.verticalSpace,
          Text(
            msg,
            style: AppTextStyles.medium.copyWith(
              fontSize: 18.sp,
              color: AppColors.primary,
            ),
          )
        ],
      ),
    );
  }
}
