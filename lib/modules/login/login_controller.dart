import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final isLoading = false.obs;
  final obscure = true.obs;

  Future<void> login() async {
    // no blocking validation (as you requested)
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;

    Get.offAllNamed(Routes.dashboard);
  }

  void goToResetPassword() {
    Get.toNamed(Routes.resetPassword);
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }
}
