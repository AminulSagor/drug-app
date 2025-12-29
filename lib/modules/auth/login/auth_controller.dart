import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/user_model.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/auth_storage.dart';
import '../../../routes/app_routes.dart';
import 'models/login_models.dart';
import '../services/auth_api.dart';

class AuthController extends GetxController {
  final AuthApi _api;
  final AuthStorage _storage;

  AuthController({AuthApi? api, AuthStorage? storage})
    : _api = api ?? AuthApi(),
      _storage = storage ?? AuthStorage();

  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final isLoading = false.obs;
  final obscure = true.obs;

  final user = Rxn<UserModel>();

  /// ✅ IMPORTANT: call this on app start (before runApp) OR as fallback in onInit
  Future<void> restoreSession() async {
    final token = await _storage.readToken();

    if (token == null || token.trim().isEmpty) {
      user.value = null;
      return;
    }

    final cachedUser = await _storage.readUser();
    user.value = cachedUser; // can be null if not stored (still ok)
  }

  /// Optional: keep if you want manual redirect later
  Future<void> checkAndRedirect() async {
    await restoreSession();
    final token = await _storage.readToken();

    if (token != null && token.trim().isNotEmpty) {
      Get.offAllNamed(Routes.shell);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      final res = await _api.login(
        LoginRequest(
          phoneNumber: phoneCtrl.text.trim(),
          password: passCtrl.text,
        ),
      );

      // ✅ api.login already saved token + user in storage, just keep in memory too
      user.value = res.user;

      Get.offAllNamed(Routes.shell);
    } on ApiException catch (e) {
      Get.snackbar('Login Failed', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _api.logout();

      // ✅ ensure memory also cleared
      user.value = null;

      Get.offAllNamed(Routes.login);
    } on ApiException catch (e) {
      // even if api fails, AuthApi.logout() clears storage already
      user.value = null;
      Get.snackbar('Logout', e.message);
      Get.offAllNamed(Routes.login);
    } finally {
      isLoading.value = false;
    }
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
