import 'package:flutter/material.dart';
import '../utils/dt_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? leadingIcon;
  final IconData? suffixIcon;
  final VoidCallback onPressed;
  final Color? bottonColor;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Color? textColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.leadingIcon,
    this.suffixIcon,
    this.borderRadius,
    this.bottonColor,
    this.height,
    this.width,
    this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.h,
      child: TextButton(

        onPressed: onPressed,
        style: ButtonStyle(

          side: MaterialStateProperty.all(BorderSide(color: AppColors.primaryColor)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 4.0)),
          ),
          backgroundColor: MaterialStateProperty.all(bottonColor ?? Colors.transparent),
          foregroundColor: MaterialStateProperty.all(textColor ?? Colors.black),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 13.0)),
          textStyle: MaterialStateProperty.all(TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          )),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) Icon(leadingIcon),
            if (leadingIcon != null) SizedBox(width: 12.0),
            Text(text),
            if (suffixIcon != null) SizedBox(width: 12.0),
            if (suffixIcon != null) Icon(suffixIcon),
          ],
        ),
      ),
    );
  }
}
