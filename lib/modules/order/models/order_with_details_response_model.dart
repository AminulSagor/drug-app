import '../../../core/models/drug_item_model.dart';

class OrderWithDetailsResponseModel {
  final int progress;
  final int cancelled;
  final int delivered;
  final OrdersPageModel orders;

  const OrderWithDetailsResponseModel({
    required this.progress,
    required this.cancelled,
    required this.delivered,
    required this.orders,
  });

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  factory OrderWithDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderWithDetailsResponseModel(
      progress: _i(json['progress']),
      cancelled: _i(json['cancelled']),
      delivered: _i(json['delivered']),
      orders: OrdersPageModel.fromJson(
        (json['orders'] as Map<String, dynamic>? ?? const {}),
      ),
    );
  }
}

class OrdersPageModel {
  final int currentPage;
  final List<OrderWithDetailsModel> data;

  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;

  final List<PageLinkModel> links;

  final String nextPageUrl;
  final String path;
  final int perPage;
  final String prevPageUrl;
  final int to;
  final int total;

  const OrdersPageModel({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _s(dynamic v) => (v ?? '').toString();

  factory OrdersPageModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final list = (rawData is List)
        ? rawData
              .where((e) => e is Map<String, dynamic>)
              .map(
                (e) =>
                    OrderWithDetailsModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <OrderWithDetailsModel>[];

    final rawLinks = json['links'];
    final linkList = (rawLinks is List)
        ? rawLinks
              .where((e) => e is Map<String, dynamic>)
              .map((e) => PageLinkModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <PageLinkModel>[];

    return OrdersPageModel(
      currentPage: _i(json['current_page']),
      data: list,
      firstPageUrl: _s(json['first_page_url']),
      from: _i(json['from']),
      lastPage: _i(json['last_page']),
      lastPageUrl: _s(json['last_page_url']),
      links: linkList,
      nextPageUrl: _s(json['next_page_url']),
      path: _s(json['path']),
      perPage: _i(json['per_page']),
      prevPageUrl: _s(json['prev_page_url']),
      to: _i(json['to']),
      total: _i(json['total']),
    );
  }
}

class PageLinkModel {
  final String url;
  final String label;
  final bool active;

  const PageLinkModel({
    required this.url,
    required this.label,
    required this.active,
  });

  static String _s(dynamic v) => (v ?? '').toString();

  factory PageLinkModel.fromJson(Map<String, dynamic> json) {
    return PageLinkModel(
      url: _s(json['url']),
      label: _s(json['label']),
      active: (json['active'] == true),
    );
  }
}

/// ✅ FIXED: order_prescriptions object model
class OrderPrescriptionModel {
  final int id;
  final int orderId;
  final String prescriptionCopy; // filename
  final String prescriptionCopyPath; // full URL ✅
  final String createdAt;
  final String updatedAt;

  const OrderPrescriptionModel({
    required this.id,
    required this.orderId,
    required this.prescriptionCopy,
    required this.prescriptionCopyPath,
    required this.createdAt,
    required this.updatedAt,
  });

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _s(dynamic v) => (v ?? '').toString();

  factory OrderPrescriptionModel.fromJson(Map<String, dynamic> json) {
    // Your correct field: prescription_copy_path ✅
    final url = _s(
      json['prescription_copy_path'] ??
          json['file_url'] ??
          json['url'] ??
          json['image'] ??
          json['path'],
    ).trim();

    return OrderPrescriptionModel(
      id: _i(json['id']),
      orderId: _i(json['order_id']),
      prescriptionCopy: _s(json['prescription_copy']).trim(),
      prescriptionCopyPath: url,
      createdAt: _s(json['created_at']),
      updatedAt: _s(json['updated_at']),
    );
  }

  bool get hasUrl => prescriptionCopyPath.trim().isNotEmpty;
}

class OrderWithDetailsModel {
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

  final OrderUserModel? user;

  /// ✅ FIXED: List of objects (from API)
  final List<OrderPrescriptionModel> prescriptions;

  final List<OrderItemApiModel> orderItems;

  const OrderWithDetailsModel({
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
    required this.user,
    required this.prescriptions,
    required this.orderItems,
  });

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _n(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  static String _s(dynamic v) => (v ?? '').toString();

  static List<OrderPrescriptionModel> _parsePrescriptions(dynamic raw) {
    if (raw is! List) return <OrderPrescriptionModel>[];

    final list = <OrderPrescriptionModel>[];

    for (final e in raw) {
      if (e is Map<String, dynamic>) {
        final p = OrderPrescriptionModel.fromJson(e);
        if (p.hasUrl) list.add(p);
      } else if (e is String) {
        // fallback: if backend ever returns list of strings
        final url = e.trim();
        if (url.isNotEmpty) {
          list.add(
            OrderPrescriptionModel(
              id: 0,
              orderId: 0,
              prescriptionCopy: '',
              prescriptionCopyPath: url,
              createdAt: '',
              updatedAt: '',
            ),
          );
        }
      }
    }

    return list;
  }

  factory OrderWithDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['order_items'];
    final items = (rawItems is List)
        ? rawItems
              .where((e) => e is Map<String, dynamic>)
              .map((e) => OrderItemApiModel.fromJson(e as Map<String, dynamic>))
              .toList()
        : <OrderItemApiModel>[];

    final rawUser = json['users'];
    final OrderUserModel? u = (rawUser is Map<String, dynamic>)
        ? OrderUserModel.fromJson(rawUser)
        : null;

    final pres = _parsePrescriptions(json['order_prescriptions']);

    return OrderWithDetailsModel(
      id: _i(json['id']),
      userId: _i(json['user_id']),
      pharmacyId: _i(json['pharmacy_id']),
      orderNo: _s(json['orderNo']),
      type: _s(json['type']),
      area: _s(json['area']),
      paymentMethod: _s(json['payment_method']),
      offerTotalAmount: _n(json['offer_total_amount']),
      status: _s(json['status']),
      deliveryCharge: _n(json['deliveryCharge']),
      offerDeliveryCharge: _n(json['offer_deliveryCharge']),
      offerGrandTotal: _n(json['offer_grandTotal']),
      comissionAmount: _n(json['comission_amount']),
      deliveryConfirmationCode: _i(json['delivery_confirmation_code']),
      orderDate: _s(json['orderDate']),
      coupon: json['coupon'],
      createdAt: _s(json['created_at']),
      updatedAt: _s(json['updated_at']),
      user: u,
      prescriptions: pres,
      orderItems: items,
    );
  }

  // -------- UI helpers ----------
  String get customerFirstName => (user?.firstName ?? '').trim();
  String get customerPhone => (user?.phoneNumber ?? '').trim();
  bool get isSelfPickup => type.toLowerCase() == 'self_pickup';

  /// ✅ UI will use these
  List<String> get prescriptionUrls => prescriptions
      .map((e) => e.prescriptionCopyPath.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  bool get hasPrescriptions => prescriptionUrls.isNotEmpty;
}

class OrderUserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const OrderUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _s(dynamic v) => (v ?? '').toString();

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      id: _i(json['id']),
      firstName: _s(json['firstName']),
      lastName: _s(json['lastName']),
      phoneNumber: _s(json['phoneNumber']),
    );
  }
}

class OrderItemApiModel {
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

  const OrderItemApiModel({
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

  static int _i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }

  static num _n(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  static String _s(dynamic v) => (v ?? '').toString();

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    final rawProduct = json['product'];
    final DrugItemModel? p = (rawProduct is Map<String, dynamic>)
        ? DrugItemModel.fromJson(rawProduct)
        : null;

    return OrderItemApiModel(
      id: _i(json['id']),
      orderId: _i(json['order_id']),
      productId: _i(json['product_id']),
      discountUnitPrice: _n(json['discount_unit_price']),
      offerUnitPrice: _n(json['offer_unit_price']),
      quantity: _i(json['quantity']),
      totalPrice: _n(json['total_price']),
      createdAt: _s(json['created_at']),
      updatedAt: _s(json['updated_at']),
      product: p,
    );
  }
}
