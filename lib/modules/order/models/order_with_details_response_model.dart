import '../../../core/utils/currency_formatter.dart';

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

  factory OrderWithDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderWithDetailsResponseModel(
      progress: _parseInt(json['progress']),
      cancelled: _parseInt(json['cancelled']),
      delivered: _parseInt(json['delivered']),
      orders: OrdersPageModel.fromJson(
        json['orders'] is Map<String, dynamic>
            ? json['orders'] as Map<String, dynamic>
            : const {},
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

  factory OrdersPageModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawLinks = json['links'];

    return OrdersPageModel(
      currentPage: _parseInt(json['current_page']),
      data: rawData is List
          ? rawData
                .whereType<Map<String, dynamic>>()
                .map(OrderWithDetailsModel.fromJson)
                .toList()
          : <OrderWithDetailsModel>[],
      firstPageUrl: _parseString(json['first_page_url']),
      from: _parseInt(json['from']),
      lastPage: _parseInt(json['last_page']),
      lastPageUrl: _parseString(json['last_page_url']),
      links: rawLinks is List
          ? rawLinks
                .whereType<Map<String, dynamic>>()
                .map(PageLinkModel.fromJson)
                .toList()
          : <PageLinkModel>[],
      nextPageUrl: _parseString(json['next_page_url']),
      path: _parseString(json['path']),
      perPage: _parseInt(json['per_page']),
      prevPageUrl: _parseString(json['prev_page_url']),
      to: _parseInt(json['to']),
      total: _parseInt(json['total']),
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

  factory PageLinkModel.fromJson(Map<String, dynamic> json) {
    return PageLinkModel(
      url: _parseString(json['url']),
      label: _parseString(json['label']),
      active: json['active'] == true,
    );
  }
}

class OrderWithDetailsModel {
  final int id;
  final int userId;
  final int pharmacyId;
  final String orderNo;
  final String type;
  final int requiredPrepaid;
  final String requiredPrepaidFor;
  final num subtotal;
  final num pharmacyBasePrice;
  final num payableToPharmacy;
  final num platformMargin;
  final String status;
  final int deliveryConfirmationCode;
  final String paymentStatus;
  final String paymentMethod;
  final String orderDate;
  final String priority;
  final dynamic coupon;
  final String createdAt;
  final String updatedAt;
  final OrderUserModel? user;
  final List<OrderPrescriptionModel> orderPrescriptions;
  final List<OrderPaymentModel> orderPayments;
  final List<OrderItemApiModel> orderItems;
  final num calculatedSubtotal;
  final String calculatedPlatformCharge;
  final int isAllowedPicked;
  final String collectLabel;

  const OrderWithDetailsModel({
    required this.id,
    required this.userId,
    required this.pharmacyId,
    required this.orderNo,
    required this.type,
    required this.requiredPrepaid,
    required this.requiredPrepaidFor,
    required this.subtotal,
    required this.pharmacyBasePrice,
    required this.payableToPharmacy,
    required this.platformMargin,
    required this.status,
    required this.deliveryConfirmationCode,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.orderDate,
    required this.priority,
    required this.coupon,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.orderPrescriptions,
    required this.orderPayments,
    required this.orderItems,
    required this.calculatedSubtotal,
    required this.calculatedPlatformCharge,
    required this.isAllowedPicked,
    required this.collectLabel,
  });

  factory OrderWithDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawUser = json['user'];
    final rawPrescriptions = json['order_prescriptions'];
    final rawPayments = json['order_payments'];
    final rawItems = json['order_items'];

    return OrderWithDetailsModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      pharmacyId: _parseInt(json['pharmacy_id']),
      orderNo: _parseString(json['orderNo'] ?? json['order_no']),
      type: _parseString(json['type']),
      requiredPrepaid: _parseInt(json['required_prepaid']),
      requiredPrepaidFor: _parseString(json['required_prepaid_for']),
      subtotal: _parseNum(json['subtotal']),
      pharmacyBasePrice: _parseNum(json['pharmacy_base_price']),
      payableToPharmacy: _parseNum(json['payable_to_pharmacy']),
      platformMargin: _parseNum(json['platform_margin']),
      status: _parseString(json['status']),
      deliveryConfirmationCode: _parseInt(json['delivery_confirmation_code']),
      paymentStatus: _parseString(json['payment_status']),
      paymentMethod: _parseString(json['payment_method']),
      orderDate: _parseString(json['orderDate'] ?? json['order_date']),
      priority: _parseString(json['priority']),
      coupon: json['coupon'],
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      user: rawUser is Map<String, dynamic>
          ? OrderUserModel.fromJson(rawUser)
          : null,
      orderPrescriptions: rawPrescriptions is List
          ? rawPrescriptions
                .whereType<Map<String, dynamic>>()
                .map(OrderPrescriptionModel.fromJson)
                .toList()
          : <OrderPrescriptionModel>[],
      orderPayments: rawPayments is List
          ? rawPayments
                .whereType<Map<String, dynamic>>()
                .map(OrderPaymentModel.fromJson)
                .toList()
          : <OrderPaymentModel>[],
      orderItems: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(OrderItemApiModel.fromJson)
                .toList()
          : <OrderItemApiModel>[],
      calculatedSubtotal: _parseNum(json['calculated_subtotal']),
      calculatedPlatformCharge: _parseString(
        json['calculated_platform_charge'],
      ),
      isAllowedPicked: _parseInt(json['is_allowed_picked']),
      collectLabel: _parseString(json['collectLabel'] ?? json['collect_label']),
    );
  }

  String get customerFirstName => user?.firstName.trim() ?? '';
  String get customerPhone => user?.phoneNumber.trim() ?? '';
  bool get isSelfPickup => type.toLowerCase() == 'self_pickup';

  String get subtotalText => formatMoney(subtotal);
  String get pharmacyBasePriceText => formatMoney(pharmacyBasePrice);
  String get payableToPharmacyText => formatMoney(payableToPharmacy);
  String get platformMarginText => formatMoney(platformMargin);
  String get calculatedSubtotalText => formatMoney(calculatedSubtotal);

  List<String> get prescriptionUrls => orderPrescriptions
      .map((e) => e.prescriptionCopyImagePath.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  bool get hasPrescriptions => prescriptionUrls.isNotEmpty;
}

class OrderUserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String phoneNumberVerifiedAt;
  final String bloodGroup;
  final int donateBlood;
  final int termsConditions;
  final int status;
  final String segment;
  final String refBy;
  final String createdAt;
  final String updatedAt;

  const OrderUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.phoneNumberVerifiedAt,
    required this.bloodGroup,
    required this.donateBlood,
    required this.termsConditions,
    required this.status,
    required this.segment,
    required this.refBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      id: _parseInt(json['id']),
      firstName: _parseString(json['firstName']),
      lastName: _parseString(json['lastName']),
      phoneNumber: _parseString(json['phoneNumber']),
      phoneNumberVerifiedAt: _parseString(json['phoneNumber_verified_at']),
      bloodGroup: _parseString(json['bloodGroup']),
      donateBlood: _parseInt(json['donateBlood']),
      termsConditions: _parseInt(json['termsConditions']),
      status: _parseInt(json['status']),
      segment: _parseString(json['segment']),
      refBy: _parseString(json['ref_by']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }
}

class OrderPrescriptionModel {
  final int id;
  final int orderId;
  final String prescriptionCopy;
  final String createdAt;
  final String updatedAt;
  final String prescriptionCopyImagePath;

  const OrderPrescriptionModel({
    required this.id,
    required this.orderId,
    required this.prescriptionCopy,
    required this.createdAt,
    required this.updatedAt,
    required this.prescriptionCopyImagePath,
  });

  factory OrderPrescriptionModel.fromJson(Map<String, dynamic> json) {
    return OrderPrescriptionModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      prescriptionCopy: _parseString(json['prescription_copy']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      prescriptionCopyImagePath: _parseString(
        json['prescription_copy_image_path'],
      ),
    );
  }

  bool get hasUrl => prescriptionCopyImagePath.trim().isNotEmpty;
}

class OrderPaymentModel {
  final int id;
  final int orderId;
  final int userId;
  final String paymentMethod;
  final String paymentChannel;
  final String transactionId;
  final String paymentType;
  final num amount;
  final String status;
  final String paidAt;
  final String verifiedByType;
  final String verifiedById;
  final String verifiedAt;
  final String createdAt;
  final String updatedAt;

  const OrderPaymentModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.paymentMethod,
    required this.paymentChannel,
    required this.transactionId,
    required this.paymentType,
    required this.amount,
    required this.status,
    required this.paidAt,
    required this.verifiedByType,
    required this.verifiedById,
    required this.verifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderPaymentModel.fromJson(Map<String, dynamic> json) {
    return OrderPaymentModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      userId: _parseInt(json['user_id']),
      paymentMethod: _parseString(json['payment_method']),
      paymentChannel: _parseString(json['payment_channel']),
      transactionId: _parseString(json['transaction_id']),
      paymentType: _parseString(json['payment_type']),
      amount: _parseNum(json['amount']),
      status: _parseString(json['status']),
      paidAt: _parseString(json['paid_at']),
      verifiedByType: _parseString(json['verified_by_type']),
      verifiedById: _parseString(json['verified_by_id']),
      verifiedAt: _parseString(json['verified_at']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  String get amountText => formatMoney(amount);
}

class OrderItemApiModel {
  final int id;
  final int productId;
  final int quantity;
  final num unitPrice;
  final num unitTotal;
  final OrderProductModel? product;

  const OrderItemApiModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.unitTotal,
    required this.product,
  });

  factory OrderItemApiModel.fromJson(Map<String, dynamic> json) {
    final rawProduct = json['product'];

    return OrderItemApiModel(
      id: _parseInt(json['id']),
      productId: _parseInt(json['product_id']),
      quantity: _parseInt(json['quantity']),
      unitPrice: _parseNum(json['unit_price']),
      unitTotal: _parseNum(json['unit_total']),
      product: rawProduct is Map<String, dynamic>
          ? OrderProductModel.fromJson(rawProduct)
          : null,
    );
  }

  String get unitPriceText => formatMoney(unitPrice);
  String get unitTotalText => formatMoney(unitTotal);
}

class OrderProductModel {
  final int id;
  final String productName;
  final String genericName;
  final num retailMaxPrice;
  final int cartQtyInc;
  final String cartText;
  final String unitInPack;
  final String type;
  final String quantity;
  final String prescription;
  final String feature;
  final String status;
  final String coverImage;
  final int companyId;
  final int categoryId;
  final String productCoverImagePath;

  const OrderProductModel({
    required this.id,
    required this.productName,
    required this.genericName,
    required this.retailMaxPrice,
    required this.cartQtyInc,
    required this.cartText,
    required this.unitInPack,
    required this.type,
    required this.quantity,
    required this.prescription,
    required this.feature,
    required this.status,
    required this.coverImage,
    required this.companyId,
    required this.categoryId,
    required this.productCoverImagePath,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: _parseInt(json['id']),
      productName: _parseString(json['productName']),
      genericName: _parseString(json['genericName']),
      retailMaxPrice: _parseNum(json['retail_max_price']),
      cartQtyInc: _parseInt(json['cart_qty_inc']),
      cartText: _parseString(json['cart_text']),
      unitInPack: _parseString(json['unit_in_pack']),
      type: _parseString(json['type']),
      quantity: _parseString(json['quantity']),
      prescription: _parseString(json['prescription']),
      feature: _parseString(json['feature']),
      status: _parseString(json['status']),
      coverImage: _parseString(json['coverImage']),
      companyId: _parseInt(json['company_id']),
      categoryId: _parseInt(json['category_id']),
      productCoverImagePath: _parseString(json['product_cover_image_path']),
    );
  }

  String get retailMaxPriceText => formatMoney(retailMaxPrice);
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
