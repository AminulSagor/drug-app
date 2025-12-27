import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AuthBackground(),
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
                    color: const Color(0xFFD9F4FF).withOpacity(.70),
                    border: Border.all(
                      color: const Color(0xFFA9A9A9),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(4, 6),
                      ),
                    ],
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
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1D2B4F),
                              ),
                            ),
                            6.verticalSpace,
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1D2B4F),
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
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      8.verticalSpace,
                      _InputBox(controller: controller.phoneCtrl),

                      18.verticalSpace,

                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      8.verticalSpace,
                      Obx(() {
                        return _InputBox(
                          controller: controller.passCtrl,
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
                              fontWeight: FontWeight.w800,
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
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w900,
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
  final bool obscureText;
  final Widget? suffix;

  const _InputBox({
    required this.controller,
    this.obscureText = false,
    this.suffix,
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
        obscureText: obscureText,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          suffixIcon: suffix == null
              ? null
              : SizedBox(height: 44.h, child: suffix),
        ),
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset('assets/auth_bg.jpg', fit: BoxFit.cover),
    );
  }
}
