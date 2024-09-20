import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String categoryText;
  final TextStyle categoryStyle;
  final Color selectedColor;
  final Color borderColor;
  final double borderRadius;
  final bool isSelected;

  const CategoryWidget({
    super.key,
    required this.onPressed,
    required this.categoryText,
    required this.categoryStyle,
    required this.selectedColor,
    required this.borderColor,
    required this.borderRadius,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      minSize: 0,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          color: isSelected ? selectedColor : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        child: Text(
          categoryText,
          textAlign: TextAlign.center,
          style: categoryStyle,
        ),
      ),
    );
  }
}