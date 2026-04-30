import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../routes/app_routes.dart';
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
      AppSnackbar.info('Enter a valid phone number', title: 'Invalid');
      return;
    }

    isSendingOtp.value = true;
    try {
      final msg = await _api.sendOtp(number: phone);

      if (_looksLikeErrorMessage(msg)) {
        AppSnackbar.failed(msg, title: 'OTP Failed');
      } else {
        AppSnackbar.info(msg, title: 'OTP');
        otpSent.value = true;
        otpVerified.value = false;
      }
    } on ApiException catch (e) {
      AppSnackbar.failed(e.message, title: 'Error');
    } catch (_) {
      AppSnackbar.failed('Something went wrong. Please try again.', title: 'Error');
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<void> verifyOtp() async {
    final phone = _phone();
    final otpStr = _otpText();
    final otp = int.tryParse(otpStr);

    if (!_isValidPhone(phone)) {
      AppSnackbar.info('Enter a valid phone number', title: 'Invalid');
      return;
    }
    if (otp == null || otpStr.length < 4) {
      AppSnackbar.info('Enter a valid OTP', title: 'Invalid');
      return;
    }

    isVerifying.value = true;
    try {
      final msg = await _api.verifyOtp(number: phone, otp: otp);

      if (_looksLikeErrorMessage(msg)) {
        AppSnackbar.failed(msg, title: 'OTP Failed');
        otpVerified.value = false;
      } else {
        AppSnackbar.success(msg, title: 'OTP Verified');
        otpVerified.value = true;
      }
    } on ApiException catch (e) {
      AppSnackbar.failed(e.message, title: 'Error');
    } catch (_) {
      AppSnackbar.failed('Something went wrong. Please try again.', title: 'Error');
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
      AppSnackbar.info('Please send OTP first', title: 'Step');
      return;
    }
    if (!otpVerified.value) {
      AppSnackbar.info('Please verify OTP first', title: 'Step');
      return;
    }
    if (!_isValidPhone(phone)) {
      AppSnackbar.info('Enter a valid phone number', title: 'Invalid');
      return;
    }
    if (otp == null) {
      AppSnackbar.info('Enter a valid OTP', title: 'Invalid');
      return;
    }
    if (pass.length < 6) {
      AppSnackbar.info('Password must be at least 6 characters', title: 'Invalid');
      return;
    }

    isChanging.value = true;
    try {
      final msg = await _api.passwordReset(
        phoneNumber: phone,
        otp: otp,
        password: pass,
      );

      if (_looksLikeErrorMessage(msg)) {
        AppSnackbar.failed(msg, title: 'Reset Failed');
        return;
      }

      AppSnackbar.success(msg, title: 'Password Changed');
      await Future.delayed(const Duration(milliseconds: 650));
      Get.offAllNamed(Routes.login);
    } on ApiException catch (e) {
      AppSnackbar.failed(e.message, title: 'Error');
    } catch (_) {
      AppSnackbar.failed('Something went wrong. Please try again.', title: 'Error');
    } finally {
      isChanging.value = false;
    }
  }

  void goToLogin() {
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    otpCtrl.dispose();
    newPassCtrl.dispose();
    super.onClose();
  }
}
