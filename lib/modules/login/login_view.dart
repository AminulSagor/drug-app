import 'package:drug/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widgets/auth_background.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AuthBackground(
            assetPath: 'assets/auth_bg.jpg',
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
                              'Login',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: AppPalette.title,
                              ),
                            ),
                          ],
                        ),
                      ),
                      22.verticalSpace,

                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      8.verticalSpace,
                      _InputBox(
                        controller: controller.phoneCtrl,
                        hint: '',
                        keyboardType: TextInputType.phone,
                      ),

                      18.verticalSpace,

                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      8.verticalSpace,
                      Obx(() {
                        return _InputBox(
                          controller: controller.passCtrl,
                          hint: '',
                          obscureText: controller.obscure.value,
                          suffix: InkWell(
                            onTap: () => controller.obscure.value =
                                !controller.obscure.value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Icon(
                                controller.obscure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                size: 18.sp,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        );
                      }),

                      10.verticalSpace,

                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: controller.goToResetPassword,
                          child: Text(
                            'Forgot Password ?',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),

                      14.verticalSpace,

                      Obx(() {
                        return SizedBox(
                          height: 48.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.login,
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      }),

                      120.verticalSpace,
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
  final Widget? suffix;

  const _InputBox({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppPalette.textFieldFill,
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
          suffixIcon: suffix == null
              ? null
              : SizedBox(height: 28.h, child: suffix),
        ),
      ),
    );
  }
}
