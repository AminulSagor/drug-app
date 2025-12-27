import 'package:drug/core/theme/app_palette.dart';
import 'package:drug/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/widgets/auth_background.dart';
import 'reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackground(
            assetPath: 'assets/auth_bg.jpg', // ✅ change if needed
            fit: BoxFit.cover,
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 18.h),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F6F6).withAlpha(128),
                    border: Border.all(
                      color: const Color(0xFFA9A9A9),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      6.verticalSpace,
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'MEDI-STOCK',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.title,
                              ),
                            ),
                            6.verticalSpace,
                            Text(
                              'Rest-Password',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.title,
                              ),
                            ),
                          ],
                        ),
                      ),
                      30.verticalSpace,

                      Row(
                        children: [
                          Expanded(
                            child: _InputBox(
                              controller: controller.phoneCtrl,
                              hint: 'Enter Phone-Number',
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          Obx(() {
                            return CustomButton(
                              btnText: 'Send OTP',
                              onTap: controller.isSendingOtp.value
                                  ? null
                                  : controller.sendOtp,
                              isLoading: controller.isSendingOtp.value,
                            );
                          }),
                        ],
                      ),

                      14.verticalSpace,

                      Row(
                        children: [
                          Expanded(
                            child: _InputBox(
                              controller: controller.otpCtrl,
                              hint: 'Enter OTP',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Obx(() {
                            return CustomButton(
                              btnText: 'Verify OTP',
                              onTap: controller.isVerifying.value
                                  ? null
                                  : controller.verifyOtp,
                              isLoading: controller.isVerifying.value,
                            );
                          }),
                        ],
                      ),

                      14.verticalSpace,

                      _InputBox(
                        controller: controller.newPassCtrl,
                        hint: 'Enter new password',
                        obscureText: true,
                      ),

                      18.verticalSpace,

                      Obx(() {
                        return CustomButton(
                          btnText: 'Change Password',
                          onTap: controller.isChanging.value
                              ? null
                              : controller.changePassword,
                          isLoading: controller.isChanging.value,
                          width: double.infinity,
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        );
                      }),

                      140.h.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;

  const _InputBox({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: const Color(0xFFDCDCDC),
        border: Border.all(color: const Color(0xFF9A9A9A), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14.sp, color: Colors.black54),
        ),
      ),
    );
  }
}
