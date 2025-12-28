import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../services/auth_api.dart';

class ResetPasswordController extends GetxController {
  ResetPasswordController({AuthApi? api}) : _api = api ?? AuthApi();
  final AuthApi _api;

  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  final newPassCtrl = TextEditingController();

  final isSendingOtp = false.obs;
  final isVerifying = false.obs;
  final isChanging = false.obs;

  final otpSent = false.obs;
  final otpVerified = false.obs;

  String _phone() => phoneCtrl.text.trim();
  String _otpText() => otpCtrl.text.trim();
  String _pass() => newPassCtrl.text;

  bool _isValidPhone(String v) {
    final digitsOnly = RegExp(r'^\d+$');
    return v.length >= 10 && v.length <= 15 && digitsOnly.hasMatch(v);
  }

  bool _looksLikeErrorMessage(String msg) {
    final m = msg.toLowerCase();
    return m.contains('not found') ||
        m.contains('invalid') ||
        m.contains('expired') ||
        m.contains('wrong') ||
        m.contains('failed') ||
        m.contains('error') ||
        m.contains('unauthorized');
  }

  Future<void> sendOtp() async {
    final phone = _phone();
    if (!_isValidPhone(phone)) {
      Get.snackbar('Invalid', 'Enter a valid phone number');
      return;
    }

    isSendingOtp.value = true;
    try {
      final msg = await _api.sendOtp(number: phone);

      // ✅ always show server message
      Get.snackbar('OTP', msg);

      // ✅ set state only if message not error-like
      if (!_looksLikeErrorMessage(msg)) {
        otpSent.value = true;
        otpVerified.value = false;
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final phone = _phone();
    final otpStr = _otpText();
    final otp = int.tryParse(otpStr);

    if (!_isValidPhone(phone)) {
      Get.snackbar('Invalid', 'Enter a valid phone number');
      return;
    }
    if (otp == null || otpStr.length < 4) {
      Get.snackbar('Invalid', 'Enter a valid OTP');
      return;
    }

    isVerifying.value = true;
    try {
      final msg = await _api.verifyOtp(number: phone, otp: otp);

      // ✅ always show server message
      Get.snackbar('OTP', msg);

      if (!_looksLikeErrorMessage(msg)) {
        otpVerified.value = true;
      } else {
        otpVerified.value = false;
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> changePassword() async {
    final phone = _phone();
    final otpStr = _otpText();
    final otp = int.tryParse(otpStr);
    final pass = _pass().trim();

    if (!otpSent.value) {
      Get.snackbar('Step', 'Please send OTP first');
      return;
    }
    if (!otpVerified.value) {
      Get.snackbar('Step', 'Please verify OTP first');
      return;
    }
    if (!_isValidPhone(phone)) {
      Get.snackbar('Invalid', 'Enter a valid phone number');
      return;
    }
    if (otp == null) {
      Get.snackbar('Invalid', 'Enter a valid OTP');
      return;
    }
    if (pass.length < 6) {
      Get.snackbar('Invalid', 'Password must be at least 6 characters');
      return;
    }

    isChanging.value = true;
    try {
      final msg = await _api.passwordReset(
        phoneNumber: phone,
        otp: otp,
        password: pass,
      );

      // ✅ always show server message
      Get.snackbar('Reset', msg);

      // ✅ go back only if message not error-like
      // if (!_looksLikeErrorMessage(msg)) {
      //   Get.back(); // back to login
      // }
      Get.back(); // back to login
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } catch (_) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    } finally {
      isChanging.value = false;
    }
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    newPassCtrl.dispose();
    super.onClose();
  }
}
