import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/models/order_item_model.dart';
import '../../../core/models/order_model.dart';

class OrderDetailsDialog extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsDialog({super.key, required this.order});

  static const _primary = Color(0xFF0D2EBE);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10.w),
      backgroundColor: Colors.white,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.78,
        child: Column(
          children: [
            /// HEADER BLUE
            Container(
              color: _primary,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${order.orderNumber}   \$ ${order.totalAmount.toStringAsFixed(2)}   Com.\$ ${order.commission.toStringAsFixed(2)}',
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
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.remove_circle,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            /// SUB HEADER
            Container(
              color: _primary,
              padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
              child: Row(
                children: [
                  Icon(Icons.phone, size: 14.sp, color: Colors.white),
                  4.horizontalSpace,
                  Text(
                    order.customerPhone,
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                  10.horizontalSpace,
                  Icon(Icons.person, size: 14.sp, color: Colors.white),
                  4.horizontalSpace,
                  Expanded(
                    child: Text(
                      order.customerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.sp, color: Colors.white),
                    ),
                  ),
                  Text(
                    _statusText(order.status),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  8.horizontalSpace,
                  Text(
                    _deliveryText(order.deliveryType),
                    style: TextStyle(fontSize: 11.sp, color: Colors.white),
                  ),
                ],
              ),
            ),

            /// ITEMS
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(10.w),
                itemCount: order.items.length,
                separatorBuilder: (_, __) => 8.verticalSpace,
                itemBuilder: (_, index) {
                  final item = order.items[index];
                  return _OrderItemCard(item: item);
                },
              ),
            ),

            /// ACTION BUTTONS
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46.h,
                    color: Colors.green,
                    child: TextButton(
                      onPressed: () {},
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
                Expanded(
                  child: Container(
                    height: 46.h,
                    color: Colors.green,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Customer Peaked',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(s) {
    switch (s) {
      case OrderStatus.accepted:
        return 'Accept';
      case OrderStatus.inProgress:
        return 'Progress';
      case OrderStatus.completed:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancel';
      case OrderStatus.pending:
      default:
        return 'Pending';
    }
  }

  String _deliveryText(d) {
    return d == DeliveryType.homeDelivery ? 'Home-Delivery' : 'Self-Pickup';
  }
}

class _OrderItemCard extends StatelessWidget {
  final OrderItemModel item;
  const _OrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1F6),
        border: Border.all(color: const Color(0xFFC9CFDC)),
      ),
      child: Row(
        children: [
          Container(width: 56.w, height: 56.w, color: const Color(0xFFD7B3B3)),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.drug.productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                2.verticalSpace,
                Text(
                  item.drug.type.toLowerCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue,
                  ),
                ),
                4.verticalSpace,
                Text(
                  'Rate : \$ ${item.rate}',
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
                '\$ ${item.total.toStringAsFixed(0)}',
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
