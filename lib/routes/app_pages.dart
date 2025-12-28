import 'package:get/get.dart';

import '../modules/top_and_nav_bar/top_and_bottom_bar_binding.dart';
import '../modules/top_and_nav_bar/top_and_bottom_bar_view.dart';
import 'app_routes.dart';

import 'package:drug/modules/auth/login/login_view.dart';
import 'package:drug/modules/auth/reset_password/reset_password_binding.dart';
import 'package:drug/modules/auth/reset_password/reset_password_view.dart';

import 'package:drug/modules/dashboard/dashboard_controller.dart';
import 'package:drug/modules/dashboard/dashboard_view.dart';

import 'package:drug/modules/order/order_controller.dart';
import 'package:drug/modules/order/order_view.dart';

import '../modules/add_list/add_list_controller.dart';
import '../modules/add_list/add_list_view.dart';

import '../modules/all_list/all_list_binding.dart';
import '../modules/all_list/all_list_view.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    // ✅ Main Shell for logged-in pages
    GetPage(
      name: Routes.shell,
      page: () => const TopAndBottomBarView(),
      binding: TopAndBottomBarBinding(),
    ),

    // Auth
    GetPage(name: Routes.login, page: () => LoginView()),
    GetPage(
      name: Routes.resetPassword,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),

    // (Optional) Keep these if you still want direct navigation sometimes.
    // But tab navigation should happen inside shell's Navigator.
    GetPage(
      name: Routes.dashboard,
      page: () => DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(
          () => DashboardController(),
          fenix: true,
        );
      }),
    ),
    GetPage(
      name: Routes.order,
      page: () => OrderView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
      }),
    ),
    GetPage(
      name: Routes.addList,
      page: () => AddListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddListController>(() => AddListController(), fenix: true);
      }),
    ),
    GetPage(
      name: Routes.allList,
      page: () => AllListView(),
      binding: AllListBinding(),
    ),
  ];
}
