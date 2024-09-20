import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taskify/global/colors/colors.dart';

class CustomizedTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final VoidCallback? onSuffixIconClicked;
  final ValueChanged<String>? onChanged;
  final TextStyle style;
  final TextStyle hintStyle;
  final TextInputType fieldType;
  final bool isReadOnly;
  final bool isExpandable;
  final String? prefixIcon;
  final Color? prefixIconColor;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focusedBorder;
  final String? suffixIcon;
  final Color? suffixIconColor;
  final Color fillColor;
  final VoidCallback? onPressed;
  final FormFieldValidator<String>? validator;

  const CustomizedTextFormField({
    super.key,
    required this.controller,
    required this.style,
    required this.hintStyle,
    this.obscureText = false,
    this.hintText = "",
    this.onSuffixIconClicked,
    this.onChanged,
    this.onPressed,
    this.fieldType = TextInputType.name,
    required this.fillColor,
    this.isReadOnly = false,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.border,
    this.focusedBorder,
    this.validator,
    this.isExpandable = false,
  });

  @override
  State<CustomizedTextFormField> createState() => _CustomizedTextFormFieldState();
}

class _CustomizedTextFormFieldState extends State<CustomizedTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.isReadOnly,
      style: widget.style,
      expands: widget.isExpandable,
      minLines: widget.isExpandable ? null : 1,
      maxLines: widget.isExpandable ? null : 1,
      textAlignVertical: TextAlignVertical.top,
      onChanged: widget.onChanged,
      onTap: widget.onPressed,
      keyboardType: widget.fieldType,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      obscureText: widget.obscureText,
      validator: widget.validator,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor,
        hintFadeDuration: 500.milliseconds,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        constraints: BoxConstraints(
          maxHeight: 235.h,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Container(
                width: 20.w,
                height: 20.h,
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                child: SvgPicture.asset(
                  widget.prefixIcon.toString(),
                  colorFilter: ColorFilter.mode(
                    widget.prefixIconColor ?? (Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black),
                    BlendMode.srcIn,
                  ),
                  fit: BoxFit.scaleDown,
                ),
              )
            : null,
        prefixIconConstraints: BoxConstraints(maxHeight: 80.h, maxWidth: 80.w),
        suffixIcon: widget.suffixIcon != null
            ? widget.onSuffixIconClicked == null
                ? Container(
                    width: 20.w,
                    height: 20.h,
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SvgPicture.asset(
                      widget.suffixIcon.toString(),
                      colorFilter: ColorFilter.mode(
                        widget.suffixIconColor ?? (Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black),
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.scaleDown,
                    ),
                  )
                : CupertinoButton(
                    onPressed: widget.onSuffixIconClicked,
                    minSize: 0,
                    padding: EdgeInsets.zero,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      margin: EdgeInsets.symmetric(horizontal: 15.w),
                      child: SvgPicture.asset(
                        widget.suffixIcon.toString(),
                        colorFilter: ColorFilter.mode(
                          widget.suffixIconColor ?? (Theme.of(context).brightness == Brightness.dark ? AppColors.white : AppColors.black),
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  )
            : null,
        suffixIconConstraints: BoxConstraints(maxHeight: 80.h, maxWidth: 80.w),
        border: widget.border ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Color(0xFFC8D1D7), width: 1.0)),
        focusedBorder: widget.focusedBorder ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: Color(0xFFC8D1D7), width: 1.0)),
      ),
    );
  }
}
