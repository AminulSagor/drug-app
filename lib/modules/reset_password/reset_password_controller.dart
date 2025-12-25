import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();

  final isSendingOtp = false.obs;
  final isVerifying = false.obs;
  final isChanging = false.obs;

  final otpSent = false.obs;
  final otpVerified = false.obs;

  Future<void> sendOtp() async {
    isSendingOtp.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isSendingOtp.value = false;

    otpSent.value = true;

    // no blocking validation
    Get.snackbar('OTP', 'OTP sent (mock)');
  }

  Future<void> verifyOtp() async {
    isVerifying.value = true;
    await Future.delayed(const Duration(milliseconds: 650));
    isVerifying.value = false;

    otpVerified.value = true;
    Get.snackbar('OTP', 'OTP verified (mock)');
  }

  Future<void> changePassword() async {
    isChanging.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isChanging.value = false;

    Get.back(); // go back to Login
    Get.snackbar('Success', 'Password changed (mock)');
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    newPassCtrl.dispose();
    super.onClose();
  }
}
