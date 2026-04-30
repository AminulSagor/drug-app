import '../../../core/models/drug_item_model.dart';
import '../../../core/utils/currency_formatter.dart';

class DashboardResponseModel {
  final int totalItem;
  final num account;
  final int progressiveOrders;
  final List<PendingOrderModel> pendingOrders;

  const DashboardResponseModel({
    required this.totalItem,
    required this.account,
    required this.progressiveOrders,
    required this.pendingOrders,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    final rawPendingOrders = json['pending_orders'];

    return DashboardResponseModel(
      totalItem: _parseInt(json['total_item']),
      account: _parseNum(json['account']),
      progressiveOrders: _parseInt(json['progressive_orders']),
      pendingOrders: rawPendingOrders is List
          ? rawPendingOrders
                .whereType<Map<String, dynamic>>()
                .map(PendingOrderModel.fromJson)
                .toList()
          : <PendingOrderModel>[],
    );
  }
}

class PendingOrderModel {
  final int id;
  final int userId;
  final int pharmacyId;
  final String orderNo;
  final String type;
  final String status;
  final String paymentMethod;
  final String orderDate;
  final String priority;
  final num subtotal;
  final String platformCharge;
  final List<PendingOrderItemModel> orderItems;

  const PendingOrderModel({
    required this.id,
    required this.userId,
    required this.pharmacyId,
    required this.orderNo,
    required this.type,
    required this.status,
    required this.paymentMethod,
    required this.orderDate,
    required this.priority,
    required this.subtotal,
    required this.platformCharge,
    required this.orderItems,
  });

  PendingOrderModel copyWith({String? status}) {
    return PendingOrderModel(
      id: id,
      userId: userId,
      pharmacyId: pharmacyId,
      orderNo: orderNo,
      type: type,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      orderDate: orderDate,
      priority: priority,
      subtotal: subtotal,
      platformCharge: platformCharge,
      orderItems: orderItems,
    );
  }

  factory PendingOrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['order_items'];

    return PendingOrderModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      pharmacyId: _parseInt(json['pharmacy_id']),
      orderNo: _parseString(json['orderNo'] ?? json['order_no']),
      type: _parseString(json['type']),
      status: _parseString(json['status']),
      paymentMethod: _parseString(json['payment_method']),
      orderDate: _parseString(json['orderDate'] ?? json['order_date']),
      priority: _parseString(json['priority']),
      subtotal: _parseNum(json['subtotal']),
      platformCharge: _parseString(json['platform_charge']),
      orderItems: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(PendingOrderItemModel.fromJson)
                .toList()
          : <PendingOrderItemModel>[],
    );
  }

  bool get isSelfPickup => type.trim().toLowerCase() == 'self_pickup';

  String get deliveryTypeLabel =>
      isSelfPickup ? 'Self Pickup' : 'Home Delivery';

  String get subtotalText => _formatDisplayNumber(subtotal);
}

class PendingOrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final num unitPrice;
  final num unitTotal;
  final DrugItemModel? product;

  const PendingOrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.unitTotal,
    required this.product,
  });

  factory PendingOrderItemModel.fromJson(Map<String, dynamic> json) {
    final rawProduct = json['product'];

    return PendingOrderItemModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      productId: _parseInt(json['product_id']),
      quantity: _parseInt(json['quantity']),
      unitPrice: _parseNum(json['unit_price']),
      unitTotal: _parseNum(json['unit_total']),
      product: rawProduct is Map<String, dynamic>
          ? DrugItemModel.fromJson(rawProduct)
          : null,
    );
  }

  String get unitPriceText => _formatDisplayNumber(unitPrice);
  String get unitTotalText => _formatDisplayNumber(unitTotal);
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

num _parseNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value;
  return num.tryParse(value.toString()) ?? 0;
}

String _parseString(dynamic value) => (value ?? '').toString();

String _formatDisplayNumber(dynamic value) => formatMoney(value);
