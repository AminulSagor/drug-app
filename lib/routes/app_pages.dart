import 'package:get/get.dart';
import '../add_list/add_list_controller.dart';
import '../add_list/add_list_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = <GetPage>[
    GetPage(
      name: Routes.addList,
      page: () => AddListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddListController>(
              () => AddListController(),
        );
      }),
    ),
  ];
}
