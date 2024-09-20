import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:taskify/global/textstyle/app_text_styles.dart';

class LinearPercentageIndicator extends StatefulWidget {
  final RxDouble percentage;
  final Color completedColor;
  final Duration animationDuration;

  const LinearPercentageIndicator({
    super.key,
    required this.percentage,
    this.completedColor = Colors.black,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<LinearPercentageIndicator> createState() => _LinearPercentageIndicatorState();
}

class _LinearPercentageIndicatorState extends State<LinearPercentageIndicator> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: 0,
                end: widget.percentage.value / 100,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: widget.completedColor.withAlpha((256 * 0.5).round()),
                color: widget.completedColor,
                minHeight: 25.0.h,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 10.w,
              child: Center(
                child: Text(
                  '${widget.percentage.value.toStringAsFixed(0)}%',
                  textAlign: TextAlign.end,
                  style: AppTextStyles.medium.copyWith(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
