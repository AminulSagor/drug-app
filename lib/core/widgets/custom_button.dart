import 'package:drug/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Color? btnColor;
  final String btnText;
  final TextStyle? textStyle;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final bool isLoading;
  const CustomButton({
    super.key,
    this.btnColor,
    required this.btnText,
    this.height,
    this.width,
    this.onTap,
    this.isLoading = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 44.h,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor ?? AppPalette.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.r),
          ),
        ),
        onPressed: onTap,
        child: isLoading
            ? SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                btnText,
                style:
                    textStyle ??
                    TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
              ),
      ),
    );
  }
}
