import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/widgets/app_drawer.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/models/order_model.dart';
import 'order_controller.dart';
import 'widgets/order_details_dialog.dart';

class OrderView extends GetView<OrderController> {
  OrderView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'MEDI-STOCK',
              onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title row
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            2.verticalSpace,
                            Text(
                              'Last 60 day’s',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 28.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primary,
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

                    10.verticalSpace,

                    /// Stats card
                    _StatsCard(
                      progress: controller.progressCount,
                      cancelled: controller.cancelledCount,
                      delivered: controller.deliveredCount,
                    ),

                    10.verticalSpace,

                    /// Search row like image: "Order Number" + input
                    _SearchRow(),

                    10.verticalSpace,

                    /// List container
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const _LoadingState();
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9ECF3),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: const Color(0xFFBFC6D4)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.separated(
                            padding: EdgeInsets.all(8.w),
                            itemCount: controller.orders.length,
                            separatorBuilder: (_, __) => 6.verticalSpace,
                            itemBuilder: (_, index) {
                              final order = controller.orders[index];
                              return _OrderRow(order: order);
                            },
                          ),
                        );
                      }),
                    ),

                    10.verticalSpace,

                    /// Pagination bar
                    _PaginationBar(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchRow extends GetView<OrderController> {
  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECF3),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFBFC6D4)),
      ),
      child: Row(
        children: [
          Container(
            width: 120.w,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.r),
                bottomLeft: Radius.circular(6.r),
              ),
            ),
            child: Text(
              'Order Number',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.searchCtrl,
              onChanged: controller.onSearchChanged,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Order Number : Ex : 123456',
                hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
          Obx(() {
            final hasText = controller.searchQuery.value.isNotEmpty;
            return InkWell(
              onTap: hasText ? controller.clearSearch : null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Icon(
                  hasText ? Icons.close : Icons.search,
                  size: 18.sp,
                  color: const Color(0xFF0D2EBE),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int progress;
  final int cancelled;
  final int delivered;

  const _StatsCard({
    required this.progress,
    required this.cancelled,
    required this.delivered,
  });

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          _StatTile(title: 'Progress', value: progress),
          _StatTile(title: 'Canceled', value: cancelled),
          _StatTile(title: 'Delivered', value: delivered),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final int value;

  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          2.verticalSpace,
          Text(
            title,
            style: TextStyle(fontSize: 11.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final OrderModel order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = _statusUi(order.status);

    return InkWell(
      onTap: () => Get.dialog(OrderDetailsDialog(order: order)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFFD1D6E2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top row: order no + amount + time
            Row(
              children: [
                Text(
                  order.orderNumber,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
                10.horizontalSpace,
                Text(
                  '\$ ${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                Text(
                  '21:22:56  22-12-25',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ],
            ),

            6.verticalSpace,

            /// Bottom row: phone + name + status
            Row(
              children: [
                Icon(Icons.phone, size: 14.sp),
                4.horizontalSpace,
                Text(order.customerPhone, style: TextStyle(fontSize: 12.sp)),
                10.horizontalSpace,
                Icon(Icons.person, size: 14.sp),
                4.horizontalSpace,
                Expanded(
                  child: Text(
                    order.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                Row(
                  children: [
                    Icon(status.icon, size: 14.sp, color: status.color),
                    4.horizontalSpace,
                    Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: status.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusUi {
  final String label;
  final Color color;
  final IconData icon;
  const _StatusUi(this.label, this.color, this.icon);
}

_StatusUi _statusUi(OrderStatus s) {
  switch (s) {
    case OrderStatus.accepted:
      return const _StatusUi('Accept', Colors.green, Icons.autorenew);
    case OrderStatus.cancelled:
      return const _StatusUi('Cancel', Colors.red, Icons.cancel);
    case OrderStatus.inProgress:
      return const _StatusUi('Progress', Colors.black, Icons.autorenew);
    case OrderStatus.completed:
      return const _StatusUi('Delivered', Colors.blue, Icons.check_circle);
    case OrderStatus.pending:
    default:
      return const _StatusUi('Pending', Colors.grey, Icons.schedule);
  }
}

class _PaginationBar extends StatelessWidget {
  final OrderController c;
  const _PaginationBar(this.c);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54.h,
      color: const Color(0xFFE5E5E5),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Obx(() {
        return Row(
          children: [
            Expanded(
              child: Text(
                'Showing ${c.showingFrom}-${c.showingTo} of ${c.totalItems}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
              ),
            ),

            Row(
              children: [
                _CircleBtn(
                  icon: Icons.arrow_back,
                  onTap: c.currentPage.value <= 1 ? null : c.prevPage,
                ),
                10.horizontalSpace,
                Text(
                  '${c.currentPage.value} of ${c.totalPages}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                10.horizontalSpace,
                _CircleBtn(
                  icon: Icons.arrow_forward,
                  onTap: c.currentPage.value >= c.totalPages
                      ? null
                      : c.nextPage,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFBDBDBD) : const Color(0xFF6E6E6E),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18.sp, color: Colors.white),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 26.w,
        height: 26.w,
        child: const CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}
