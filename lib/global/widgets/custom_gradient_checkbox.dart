import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientCheckbox extends StatelessWidget {
  final bool isChecked;
  final LinearGradient gradient;
  final String checkBoxText;
  final TextStyle checkBoxTextStyle;
  final double size;
  final double radius;
  final VoidCallback onPressed;

  const GradientCheckbox({
    super.key,
    required this.isChecked,
    required this.gradient,
    required this.checkBoxText,
    required this.checkBoxTextStyle,
    this.size = 24.0,
    required this.radius,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoButton(
          onPressed: onPressed,
          minSize: 0,
          padding: EdgeInsets.zero,
          child: Container(
            width: size.w,
            height: size.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: isChecked ? gradient : null,
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                width: 1.0
              )
            ),
            child: isChecked
                ? Icon(
              Icons.check,
              color: Colors.white,
              size: size * 0.6,
            )
                : null,
          ),
        ),
        8.horizontalSpace,
        Text(
          checkBoxText,
          style: checkBoxTextStyle,
        ),
      ],
    );
  }
}
