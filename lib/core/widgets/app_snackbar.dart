import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_palette.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String title = 'Success'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppPalette.positiveFill,
      accentColor: AppPalette.positiveText,
      icon: Icons.check_circle_outline,
    );
  }

  static void failed(String message, {String title = 'Failed'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppPalette.negativeFill,
      accentColor: AppPalette.negativeText,
      icon: Icons.error_outline,
    );
  }

  static void info(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFE8E8E8),
      accentColor: AppPalette.subText,
      icon: Icons.info_outline,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color accentColor,
    required IconData icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: AppPalette.black,
      borderColor: accentColor,
      borderWidth: 1,
      borderRadius: 8,
      margin: const EdgeInsets.all(12),
      icon: Icon(icon, color: accentColor),
      duration: const Duration(seconds: 3),
    );
  }
}
