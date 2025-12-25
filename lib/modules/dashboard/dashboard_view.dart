import 'package:drug/core/models/order_model.dart';
import 'package:drug/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_palette.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/bottom_nav.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'MEDI-STOCK',
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppPalette.primary,
                        ),
                      ),
                      2.verticalSpace,
                      Text(
                        '19/12/2025',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 28.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      onPressed: controller.refreshPage,
                      child: Text(
                        'Refresh',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() {
                  /// 🔵 ONLY initial load blocks the page
                  if (controller.isPageLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children: [
                      /// 🔒 NEVER RELOADS
                      _DashboardStats(controller),

                      12.verticalSpace,

                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: controller.isOrderLoading.value
                                ? null
                                : controller.prevOrder,
                            child: Image.asset('assets/letft.png'),
                          ),
                          8.h.horizontalSpace,
                          InkWell(
                            onTap: controller.isOrderLoading.value
                                ? null
                                : controller.nextOrder,
                            child: Image.asset('assets/right.png'),
                          ),
                        ],
                      ),

                      12.verticalSpace,

                      /// 🔁 ONLY THIS PART RELOADS
                      Obx(() {
                        if (controller.isOrderLoading.value) {
                          return Container(
                            height: 220.h,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          );
                        }

                        final order = controller.orders.first;

                        return _OrderCard(
                          order: order,
                          onAccept: () => controller.acceptOrder(order),
                          onDecline: () => controller.declineOrder(order),
                        );
                      }),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _OrderCard({
    required this.order,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          Container(
            color: AppPalette.primary,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Text(
                  order.orderNumber,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const Spacer(),

                Text(
                  '\$ ${order.totalAmount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                8.horizontalSpace,
              ],
            ),
          ),

          ...order.items.map(
            (item) => Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFCDC7C7)),
              ),
              child: ListTile(
                leading: Container(
                  width: 60.w,
                  height: 60.w,
                  color: AppPalette.imageFill,
                ),
                title: Text(item.drug.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.drug.type.toLowerCase(),
                      style: const TextStyle(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Rate : \$ ${item.rate}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'QTY : ${item.quantity}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  'TOTAL\n\$ ${item.total}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: AppPalette.primary),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    btnText: 'Decline',
                    btnColor: AppPalette.negativeText,
                    onTap: onDecline,
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.white,
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: CustomButton(
                    btnText: 'Accept',
                    btnColor: AppPalette.positiveText,
                    onTap: onAccept,
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppPalette.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardStats extends StatelessWidget {
  final DashboardController c;
  const _DashboardStats(this.c);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppPalette.primary,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatTile(
                'Pending Order',
                c.pendingCount,
                iconPath: 'assets/time.png',
              ),
              _StatTile(
                'Progressive Order',
                c.progressiveCount,
                iconPath: 'assets/tick.png',
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            children: [
              _StatTile(
                'M-commission',
                c.totalCommission,
                iconPath: 'assets/dollar.png',
              ),
              _StatTile(
                'Item Listed',
                c.listedItemsCount,
                iconPath: 'assets/menu.png',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final num value;

  const _StatTile(this.title, this.value, {required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Image.asset(iconPath),
          ),
          8.w.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
