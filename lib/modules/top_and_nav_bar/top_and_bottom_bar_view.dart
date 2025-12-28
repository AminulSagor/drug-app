import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/app_header.dart';
import '../../../core/widgets/bottom_nav.dart';
import '../../../routes/app_routes.dart';

import '../dashboard/dashboard_view.dart';
import '../order/order_view.dart';
import '../add_list/add_list_view.dart';
import '../all_list/all_list_view.dart';

import 'top_and_bottom_bar_controller.dart';

class TopAndBottomBarView extends GetView<TopAndBottomBarController> {
  const TopAndBottomBarView({super.key});

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.dashboard:
        return GetPageRoute(settings: settings, page: () => DashboardView());

      case Routes.order:
        return GetPageRoute(settings: settings, page: () => OrderView());

      case Routes.addList:
        return GetPageRoute(settings: settings, page: () => AddListView());

      case Routes.allList:
        return GetPageRoute(settings: settings, page: () => AllListView());

      default:
        return GetPageRoute(settings: settings, page: () => DashboardView());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        drawer: const AppDrawer(),
        backgroundColor: Colors.white,
        bottomNavigationBar: const AppBottomNav(),

        body: SafeArea(
          child: Column(
            children: [
              // ✅ Builder context below Scaffold is not needed now,
              // because we open drawer via scaffoldKey
              AppHeader(
                title: 'MEDI-STOCK',
                onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
              ),

              Expanded(
                child: Navigator(
                  key: Get.nestedKey(1),
                  initialRoute: Routes.dashboard,
                  onGenerateRoute: _onGenerateRoute,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
