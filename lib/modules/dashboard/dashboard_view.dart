import 'package:drug/core/utils/currency_formatter.dart';
import 'package:drug/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/theme/app_palette.dart';
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
                      _todayDateText(),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '# ${order.orderNo}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                4.w.horizontalSpace,
                Text(
                  '৳. ${order.subtotalText}',
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
                4.w.horizontalSpace,
                SizedBox(
                  width: 16.w,
                  child: Image.asset(
                    order.isSelfPickup
                        ? 'assets/pickup_icon.png'
                        : 'assets/home_delivery.png',
                    color: Colors.white,
                    fit: BoxFit.cover,
                  ),
                ),
                4.w.horizontalSpace,
                Flexible(
                  child: Text(
                    order.deliveryTypeLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ),
                4.w.horizontalSpace,
                Text(
                  '৳. -${order.platformCharge}',
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
              ],
            ),
          ),

          ...order.orderItems.map((item) => _PendingOrderItemCard(item: item)),

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
                        onTap: busy ? null : onDecline,
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

class _PendingOrderItemCard extends StatelessWidget {
  final PendingOrderItemModel item;
  const _PendingOrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final imageUrl = (p?.coverImagePath ?? '').trim();
    final rawCartText = (p?.cartText ?? '').trim();
    final cartText = rawCartText.isNotEmpty
        ? rawCartText
        : (p?.type ?? '').trim();
    final unitInPack = (p?.unitInPack ?? '').trim();

    return Container(
      margin: EdgeInsets.all(8.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F6),
        border: Border.all(color: const Color(0xFFCDC7C7)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5.r),
            child: SizedBox(
              width: 70.w,
              height: 70.w,
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
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        p?.productName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      p?.strength ?? '',
                      style: TextStyle(fontSize: 11.sp, color: Colors.black),
                    ),
                  ],
                ),
                5.verticalSpace,
                Wrap(
                  spacing: 5.w,
                  runSpacing: 4.h,
                  children: [
                    if (cartText.isNotEmpty) _ProductChip(text: cartText),
                    if (unitInPack.isNotEmpty) _ProductChip(text: unitInPack),
                  ],
                ),
                7.verticalSpace,
                Text(
                  'Unit Price : ৳. ${item.unitPriceText}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black),
                ),
                5.verticalSpace,
                Text(
                  'QTY : ${item.quantity}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black),
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.primary,
                ),
              ),
              2.verticalSpace,
              Text(
                '৳. ${item.unitTotalText}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductChip extends StatelessWidget {
  final String text;
  const _ProductChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999.w),
        border: Border.all(color: Colors.grey, width: .6),
        color: Colors.white.withOpacity(.35),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
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
                _StatTile('Balance', c.balance.value, isMoney: true),
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
  final String? iconPath;
  final String title;
  final num value;
  final bool isMoney;

  const _StatTile(
    this.title,
    this.value, {
    this.iconPath,
    this.isMoney = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconPath != null)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Image.asset(iconPath!, width: 20.w),
            ),
          if (iconPath == null)
            Text(
              '৳.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          8.w.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isMoney
                      ? value > 0
                            ? '+${formatMoney(value)}'
                            : value.toStringAsFixed(2)
                      : value.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
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

String _todayDateText() {
  final now = DateTime.now();
  final day = now.day.toString().padLeft(2, '0');
  final month = now.month.toString().padLeft(2, '0');
  return '$day/$month/${now.year}';
}
