import 'package:drug/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../models/order_with_details_response_model.dart';
import '../order_controller.dart';
import 'prescription_list_dialog.dart';

class OrderDetailsDialog extends StatelessWidget {
  final OrderWithDetailsModel order;
  const OrderDetailsDialog({super.key, required this.order});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    final hasPrescriptions = order.hasPrescriptions;
    final statusUi = _statusUiFromApi(order.status);

    // ✅ get controller instance
    final c = Get.find<OrderController>();

    return Dialog(
      insetPadding: EdgeInsets.all(10.w),
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppPalette.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '# ${order.orderNo}   \$ ${order.offerTotalAmount}   Com. \$ ${order.comissionAmount}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: Get.back,
                    child: Icon(
                      Icons.remove_circle,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: _primary,
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
              child: Row(
                children: [
                  Icon(Icons.phone, size: 14.sp, color: Colors.white),
                  4.horizontalSpace,
                  Text(
                    order.customerPhone,
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  10.horizontalSpace,
                  Icon(Icons.person, size: 14.sp, color: Colors.white),
                  4.horizontalSpace,
                  Text(
                    order.customerFirstName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  10.horizontalSpace,
                  Icon(statusUi.icon, size: 14.sp, color: statusUi.color),
                  4.horizontalSpace,
                  Text(
                    statusUi.label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: statusUi.color,
                    ),
                  ),
                  10.horizontalSpace,
                  Image.asset(
                    order.isSelfPickup
                        ? 'assets/pickup_icon.png'
                        : 'assets/home_delivery.png',
                    color: Colors.white,
                    width: 16.w,
                    fit: BoxFit.cover,
                  ),
                  4.horizontalSpace,
                  Text(
                    order.isSelfPickup ? 'Self-Pickup' : 'Home-Delivery',
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                ],
              ),
            ),

            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(10.w),
              itemCount: order.orderItems.length,
              separatorBuilder: (_, __) => 10.h.verticalSpace,
              itemBuilder: (_, index) {
                final item = order.orderItems[index];
                return _OrderItemCard(item: item);
              },
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(12.w, 12.h, 6.w, 12.h),
                    height: 46.h,
                    color: hasPrescriptions ? Color(0xFF0AA888) : Colors.grey,
                    child: TextButton(
                      onPressed: hasPrescriptions
                          ? () {
                              Get.dialog(
                                PrescriptionListDialog(
                                  urls: order.prescriptionUrls,
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        'View Prescription',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                /// ✅ UPDATED BUTTON: "Peaked" + call clear order API
                Expanded(
                  child: Obx(() {
                    final isClearing = c.clearingOrderIds.contains(order.id);

                    return Container(
                      margin: EdgeInsets.fromLTRB(6.w, 12.h, 12.w, 12.h),
                      height: 46.h,
                      color: isClearing ? Colors.grey : Colors.green,
                      child: TextButton(
                        onPressed: isClearing
                            ? null
                            : () => c.clearOrder(orderId: order.id),
                        child: isClearing
                            ? SizedBox(
                                width: 18.w,
                                height: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Peaked',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// keep your _OrderItemCard exactly as you already have it
class _OrderItemCard extends StatelessWidget {
  final OrderItemApiModel item;
  const _OrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final img = (p?.coverImagePath ?? '').trim();

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F6),
        border: Border.all(color: const Color(0xFFC9CFDC)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 56.w,
              height: 56.w,
              child: img.isEmpty
                  ? Container(
                      color: const Color(0xFFD7B3B3),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 18.sp,
                        color: Colors.grey[700],
                      ),
                    )
                  : Image.network(
                      img,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFFD7B3B3),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 18.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p?.productName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                2.verticalSpace,
                Text(
                  (p?.type ?? '').toLowerCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'Rate : \$ ${item.discountUnitPrice}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                Text(
                  'QTY : ${item.quantity}',
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue,
                ),
              ),
              Text(
                '\$ ${item.totalPrice}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
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
    return const _StatusUi('Pending', Colors.white, Icons.schedule);
  }
  if (v == 'cancelled' || v == 'canceled') {
    return const _StatusUi('Cancel', Colors.red, Icons.cancel);
  }
  if (v == 'confirmed') {
    return const _StatusUi('Accept', Colors.green, Icons.check_circle);
  }
  if (v == 'delivered') {
    return const _StatusUi(
      'Delivered',
      AppPalette.positiveText,
      Icons.check_circle,
    );
  }
  if (v == 'processing' || v == 'readyforpickup' || v == 'on delivery') {
    return const _StatusUi('Progress', Colors.white, Icons.autorenew);
  }

  return const _StatusUi('Progress', Colors.white, Icons.autorenew);
}
