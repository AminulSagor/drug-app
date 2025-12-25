import 'order_item_model.dart';

enum OrderStatus { pending, accepted, inProgress, completed, cancelled }

enum DeliveryType { homeDelivery, selfPickup }

class OrderModel {
  final String orderNumber;
  final String customerName;
  final String customerPhone;

  final List<OrderItemModel> items;

  final OrderStatus status;
  final DeliveryType deliveryType;

  final num commission;

  const OrderModel({
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.status,
    required this.deliveryType,
    required this.commission,
  });

  num get totalAmount => items.fold<num>(0, (sum, item) => sum + item.total);
}
