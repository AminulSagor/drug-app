import '../../../core/models/drug_item_model.dart';

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

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['pending_orders'];

    final List<PendingOrderModel> pending = (raw is List)
        ? raw
              .where((e) => e is Map<String, dynamic>)
              .map((e) => PendingOrderModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <PendingOrderModel>[];

    return DashboardResponseModel(
      totalItem: _parseInt(json['total_item']),
      account: _parseNum(json['account']),
      progressiveOrders: _parseInt(json['progressive_orders']),
      pendingOrders: pending,
    );
  }
}

class PendingOrderModel {
  final int id;
  final int userId;
  final int pharmacyId;
  final String orderNo;

  final String type;
  final String area;
  final String paymentMethod;

  final num offerTotalAmount;
  final String status;

  final num deliveryCharge;
  final num offerDeliveryCharge;
  final num offerGrandTotal;

  final num comissionAmount;

  final int deliveryConfirmationCode;

  final String orderDate;
  final dynamic coupon;

  final String createdAt;
  final String updatedAt;

  final List<PendingOrderItemModel> orderItems;

  const PendingOrderModel({
    required this.id,
    required this.userId,
    required this.pharmacyId,
    required this.orderNo,
    required this.type,
    required this.area,
    required this.paymentMethod,
    required this.offerTotalAmount,
    required this.status,
    required this.deliveryCharge,
    required this.offerDeliveryCharge,
    required this.offerGrandTotal,
    required this.comissionAmount,
    required this.deliveryConfirmationCode,
    required this.orderDate,
    required this.coupon,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
  });

  PendingOrderModel copyWith({String? status}) {
    return PendingOrderModel(
      id: id,
      userId: userId,
      pharmacyId: pharmacyId,
      orderNo: orderNo,
      type: type,
      area: area,
      paymentMethod: paymentMethod,
      offerTotalAmount: offerTotalAmount,
      status: status ?? this.status,
      deliveryCharge: deliveryCharge,
      offerDeliveryCharge: offerDeliveryCharge,
      offerGrandTotal: offerGrandTotal,
      comissionAmount: comissionAmount,
      deliveryConfirmationCode: deliveryConfirmationCode,
      orderDate: orderDate,
      coupon: coupon,
      createdAt: createdAt,
      updatedAt: updatedAt,
      orderItems: orderItems,
    );
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  factory PendingOrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['order_items'];

    final List<PendingOrderItemModel> items = (rawItems is List)
        ? rawItems
              .where((e) => e is Map<String, dynamic>)
              .map(
                (e) =>
                    PendingOrderItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <PendingOrderItemModel>[];

    return PendingOrderModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      pharmacyId: _parseInt(json['pharmacy_id']),
      orderNo: (json['orderNo'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      area: (json['area'] ?? '').toString(),
      paymentMethod: (json['payment_method'] ?? '').toString(),
      offerTotalAmount: _parseNum(json['offer_total_amount']),
      status: (json['status'] ?? '').toString(),
      deliveryCharge: _parseNum(json['deliveryCharge']),
      offerDeliveryCharge: _parseNum(json['offer_deliveryCharge']),
      offerGrandTotal: _parseNum(json['offer_grandTotal']),
      comissionAmount: _parseNum(json['comission_amount']),
      deliveryConfirmationCode: _parseInt(json['delivery_confirmation_code']),
      orderDate: (json['orderDate'] ?? '').toString(),
      coupon: json['coupon'],
      createdAt: (json['created_at'] ?? '').toString(),
      updatedAt: (json['updated_at'] ?? '').toString(),
      orderItems: items,
    );
  }
}

class PendingOrderItemModel {
  final int id;
  final int orderId;
  final int productId;

  final num discountUnitPrice;
  final num offerUnitPrice;
  final int quantity;
  final num totalPrice;

  final String createdAt;
  final String updatedAt;

  final DrugItemModel? product;

  const PendingOrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.discountUnitPrice,
    required this.offerUnitPrice,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  factory PendingOrderItemModel.fromJson(Map<String, dynamic> json) {
    final rawProduct = json['product'];

    final DrugItemModel? product = (rawProduct is Map<String, dynamic>)
        ? DrugItemModel.fromJson(rawProduct)
        : null;

    return PendingOrderItemModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      productId: _parseInt(json['product_id']),
      discountUnitPrice: _parseNum(json['discount_unit_price']),
      offerUnitPrice: _parseNum(json['offer_unit_price']),
      quantity: _parseInt(json['quantity']),
      totalPrice: _parseNum(json['total_price']),
      createdAt: (json['created_at'] ?? '').toString(),
      updatedAt: (json['updated_at'] ?? '').toString(),
      product: product,
    );
  }
}
