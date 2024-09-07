import 'package:chat/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  final String hintText;
  final double? height;
  final double? width;
  final Color? color;
  final Color? hintColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? cursorColor;
  final Color? fillColor;
  final double? fontSize;
  final bool? password;
  final int? maxLine;
  final bool? enabled;
  final Widget? prefix;
  final Widget? suffix;
  final double? bottom;
  final double? radius;
  final double? marginHorizontal;
  final double? marginVertical;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextDirection? direction;
  final Function(String)? onChange;

  const DefaultTextField({
    required this.controller,
    required this.hintText,
    this.password,
    this.onTap,
    this.height,
    this.maxLength,
    this.color,
    this.fillColor,
    this.textColor,
    this.borderColor,
    this.cursorColor,
    this.fontSize,
    this.width,
    this.hintColor,
    this.enabled,
    this.maxLine,
    this.prefix,
    this.suffix,
    this.bottom,
    this.radius,
    this.keyboardType,
    this.marginHorizontal,
    this.marginVertical,
    this.direction,
    this.onChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 5.h,
      width: width ?? 100.w,
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal ?? 10.w,
          vertical: marginVertical ?? 1.h),
      decoration: BoxDecoration(
        color: color ?? AppColors.transparent,
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      child: TextField(
        textInputAction: TextInputAction.go,
        onSubmitted: (value) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        keyboardType: keyboardType ?? TextInputType.text,
        textAlignVertical: TextAlignVertical.center,
        enabled: enabled ?? true,
        controller: controller,
        obscureText: password ?? false,
        obscuringCharacter: "*",
        textDirection: TextDirection.ltr,
        style: TextStyle(
          color: textColor ?? AppColors.darkGrey,
          fontSize: fontSize ?? 15.sp,
        ),
        cursorColor: cursorColor ?? AppColors.black,
        maxLines: maxLine ?? 1,
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: "",
          counterStyle: const TextStyle(color: AppColors.lightGrey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.grey,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.grey,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.black,
            ),
          ),
          prefixIcon: prefix,
          suffixIcon: suffix,
          hintText: hintText,
          alignLabelWithHint: true,
          hintStyle: TextStyle(
            color: hintColor ?? AppColors.darkGrey.withOpacity(0.7),
            fontSize: 15.sp,
          ),
          border: InputBorder.none,
          hintTextDirection: TextDirection.ltr,
          filled: true,
          fillColor: fillColor ?? AppColors.white,
          contentPadding: EdgeInsets.only(
            bottom: 5.sp,
            left: 15.sp,
            right: 15.sp,
          ),
        ),
        onChanged: onChange,
      ),
    );
  }
}
