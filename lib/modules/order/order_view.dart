import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'models/order_with_details_response_model.dart';
import 'order_controller.dart';
import 'widgets/order_details_dialog.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
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

                  /// Stats card (from API)
                  Obx(
                    () => _StatsCard(
                      progress: controller.progressCount.value,
                      cancelled: controller.cancelledCount.value,
                      delivered: controller.deliveredCount.value,
                    ),
                  ),

                  10.verticalSpace,

                  /// Search row
                  _SearchRow(),

                  10.verticalSpace,

                  /// List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const _LoadingState();
                      }

                      final items = controller.orders;

                      if (items.isEmpty) {
                        return _OrderEmptyState(
                          isSearching: controller.isSearching,
                          onPrimary: controller.isSearching
                              ? controller.clearSearch
                              : controller.refreshPage,
                        );
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
                          itemCount: items.length,
                          separatorBuilder: (_, __) => 6.verticalSpace,
                          itemBuilder: (_, index) {
                            final order = items[index];
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
    );
  }
}

class _OrderEmptyState extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onPrimary;

  const _OrderEmptyState({required this.isSearching, required this.onPrimary});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    final title = isSearching ? 'No order found' : 'No orders to show';
    final subtitle = isSearching
        ? 'Check the order number and try again.'
        : 'Tap refresh to load the latest orders.';
    final btn = isSearching ? 'Clear Search' : 'Refresh';

    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            6.verticalSpace,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
            ),
            12.verticalSpace,
            SizedBox(
              height: 38.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primary,
                  elevation: 0,
                ),
                onPressed: onPrimary,
                child: Text(
                  btn,
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

              /// ✅ integer only keyboard
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],

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
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          2.verticalSpace,
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final OrderWithDetailsModel order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = _statusUiFromApi(order.status);

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
            /// top row
            Row(
              children: [
                Text(
                  '# ${order.orderNo}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
                10.horizontalSpace,
                Text(
                  '\$ ${order.offerTotalAmount}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatCreatedAt(order.createdAt),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ],
            ),

            6.verticalSpace,

            /// bottom row
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
                    order.customerFirstName,
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

/// Status rules:
/// Pending = Pending
/// Cancelled = Cancel
/// Confirmed = Accept
/// Delivered = Delivered
/// Processing, ReadyForPickup, On delivery = Progress
_StatusUi _statusUiFromApi(String s) {
  final v = s.trim().toLowerCase();

  if (v == 'pending') {
    return const _StatusUi('Pending', Colors.grey, Icons.schedule);
  }
  if (v == 'cancelled' || v == 'canceled') {
    return const _StatusUi('Cancel', Colors.red, Icons.cancel);
  }
  if (v == 'confirmed') {
    return const _StatusUi('Accept', Colors.green, Icons.check_circle);
  }
  if (v == 'delivered') {
    return const _StatusUi('Delivered', Colors.blue, Icons.check_circle);
  }
  if (v == 'processing' || v == 'readyforpickup' || v == 'on delivery') {
    return const _StatusUi('Progress', Colors.black, Icons.autorenew);
  }

  return const _StatusUi('Progress', Colors.black, Icons.autorenew);
}

String _formatCreatedAt(String raw) {
  final t = raw.trim();
  if (t.isEmpty) return '';

  // "YYYY-MM-DD HH:MM:SS"
  if (t.length >= 19 && t[4] == '-' && t[7] == '-') {
    final date = t.substring(0, 10);
    final time = t.substring(11, 19);

    final dd = date.substring(8, 10);
    final mm = date.substring(5, 7);
    final yy = date.substring(2, 4);

    return '$time  $dd-$mm-$yy';
  }

  return t;
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
                'Showing ${c.showingFrom}-${c.showingTo} of ${c.totalItems.value}',
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
                  '${c.currentPage.value} of ${c.totalPages.value}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                10.horizontalSpace,
                _CircleBtn(
                  icon: Icons.arrow_forward,
                  onTap: c.currentPage.value >= c.totalPages.value
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
