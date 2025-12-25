import 'package:drug/modules/dashboard/dashboard_controller.dart';
import 'package:drug/modules/dashboard/dashboard_view.dart';
import 'package:drug/modules/login/login_binding.dart';
import 'package:drug/modules/login/login_view.dart';
import 'package:drug/modules/order/order_controller.dart';
import 'package:drug/modules/order/order_view.dart';
import 'package:drug/modules/reset_password/reset_password_binding.dart';
import 'package:drug/modules/reset_password/reset_password_view.dart';
import 'package:get/get.dart';
import '../modules/add_list/add_list_controller.dart';
import '../modules/add_list/add_list_view.dart';
import '../modules/all_list/all_list_binding.dart';
import '../modules/all_list/all_list_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: Routes.addList,
      page: () => AddListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddListController>(() => AddListController());
      }),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.allList,
      page: () => AllListView(),
      binding: AllListBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => DashboardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<DashboardController>(() => DashboardController());
      }),
    ),
    GetPage(
      name: Routes.order,
      page: () => OrderView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OrderController>(() => OrderController());
      }),
    ),
  ];
}
