import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

import '../dashboard/dashboard_controller.dart';
import '../order/order_controller.dart';
import '../add_list/add_list_controller.dart';
import '../all_list/all_list_binding.dart';

class TopAndBottomBarController extends GetxController {
  final currentIndex = 0.obs;

  // Map tabs -> routes
  final tabRoutes = const [
    Routes.dashboard,
    Routes.order,
    Routes.addList,
    Routes.allList,
  ];

  @override
  void onInit() {
    super.onInit();
    _ensureTabInitialized(0);
  }

  void onTabTap(int index) {
    if (index == currentIndex.value) {
      return;
    }

    currentIndex.value = index;

    _ensureTabInitialized(index);

    Get.offNamed(tabRoutes[index], id: 1);
  }

  void _ensureTabInitialized(int index) {
    switch (index) {
      case 0:
        if (!Get.isRegistered<DashboardController>()) {
          Get.lazyPut<DashboardController>(() => DashboardController());
        }
        break;

      case 1:
        if (!Get.isRegistered<OrderController>()) {
          Get.lazyPut<OrderController>(() => OrderController());
        }
        break;

      case 2:
        if (!Get.isRegistered<AddListController>()) {
          Get.lazyPut<AddListController>(() => AddListController());
        }
        break;

      case 3:
        if (!Get.isRegistered<AllListBinding>()) {
          AllListBinding().dependencies();
        }
        break;
    }
  }

  Future<bool> onWillPop() async {
    final nav = Get.nestedKey(1)?.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return false;
    }
    return true;
  }
}
