import 'package:get/get.dart';

import '../auth/login/auth_controller.dart';
import 'top_and_bottom_bar_controller.dart';

class TopAndBottomBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TopAndBottomBarController>(() => TopAndBottomBarController());

    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController());
    }
  }
}
