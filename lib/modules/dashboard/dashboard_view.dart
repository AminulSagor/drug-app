import 'package:drug/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_palette.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/bottom_nav.dart';
import 'dashboard_controller.dart';
import 'models/dashboard_response_model.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
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
                if (controller.isPageLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: [
                    _DashboardStats(controller),
                    12.verticalSpace,

                    Row(
                      children: [
                        const Spacer(),
                        Obx(() {
                          final disabled =
                              controller.isOrderLoading.value ||
                              controller.orders.isEmpty;
                          return InkWell(
                            onTap: disabled ? null : controller.prevOrder,
                            child: Opacity(
                              opacity: disabled ? 0.4 : 1,
                              child: Image.asset('assets/left.png'),
                            ),
                          );
                        }),
                        8.h.horizontalSpace,
                        Obx(() {
                          final disabled =
                              controller.isOrderLoading.value ||
                              controller.orders.isEmpty;
                          return InkWell(
                            onTap: disabled ? null : controller.nextOrder,
                            child: Opacity(
                              opacity: disabled ? 0.4 : 1,
                              child: Image.asset('assets/right.png'),
                            ),
                          );
                        }),
                      ],
                    ),

                    12.verticalSpace,

                    Obx(() {
                      if (controller.isOrderLoading.value) {
                        return Container(
                          height: 220.h,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }

                      if (controller.orders.isEmpty) {
                        return _NoPendingOrders(
                          onRefresh: controller.refreshPage,
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
    );
  }
}

class _NoPendingOrders extends StatelessWidget {
  final VoidCallback onRefresh;

  const _NoPendingOrders({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FF),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFD6DDF6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 44.sp, color: AppPalette.primary),
          10.verticalSpace,
          Text(
            "No pending orders right now",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0B0F15),
            ),
          ),
          6.verticalSpace,
          Text(
            "You're all caught up. New orders will appear here automatically.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[700],
              height: 1.25,
            ),
          ),
          14.verticalSpace,
          SizedBox(
            width: 160.w,
            child: CustomButton(
              btnText: "Refresh",
              btnColor: AppPalette.primary,
              onTap: onRefresh,
              textStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final PendingOrderModel order;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _OrderCard({
    required this.order,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppPalette.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            child: Row(
              children: [
                Text(
                  '# ${order.orderNo}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$ ${order.offerTotalAmount}',
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

          ...order.orderItems.map((item) {
            final p = item.product;
            final imageUrl = (p?.coverImagePath ?? '').trim();

            return Container(
              margin: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFCDC7C7)),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: SizedBox(
                    width: 60.w,
                    height: 60.w,
                    child: imageUrl.isEmpty
                        ? Container(
                            color: AppPalette.imageFill,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 20.sp,
                              color: Colors.grey[600],
                            ),
                          )
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: AppPalette.imageFill,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 20.sp,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                  ),
                ),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(p?.productName ?? ''),
                    5.w.horizontalSpace,
                    Text(p?.strength ?? '', style: TextStyle(fontSize: 10.sp)),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (p?.type ?? ''),
                      style: const TextStyle(
                        color: AppPalette.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Rate : \$ ${item.discountUnitPrice}',
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
                  'TOTAL\n\$ ${item.totalPrice}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: AppPalette.primary),
                ),
              ),
            );
          }),

          Padding(
            padding: EdgeInsets.all(12.w),
            child: Obx(() {
              final busy = Get.find<DashboardController>().isOrderLoading.value;

              return Opacity(
                opacity: busy ? 0.6 : 1,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        btnText: 'Decline',
                        btnColor: AppPalette.negativeText,
                        onTap: busy ? null : onDecline, // prevents double tap
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
                        onTap: busy ? null : onAccept,
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppPalette.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
    return Obx(() {
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
                  c.pendingCount.value,
                  iconPath: 'assets/time.png',
                ),
                _StatTile(
                  'Progressive Order',
                  c.progressiveCount.value,
                  iconPath: 'assets/tick.png',
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                _StatTile(
                  'M-commission',
                  c.totalCommission.value,
                  iconPath: 'assets/dollar.png',
                ),
                _StatTile(
                  'Item Listed',
                  c.listedItemsCount.value,
                  iconPath: 'assets/menu.png',
                ),
              ],
            ),
          ],
        ),
      );
    });
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
