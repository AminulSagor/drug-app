class ListedItemCompanyModel {
  final int id;
  final String name;

  const ListedItemCompanyModel({required this.id, required this.name});

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  factory ListedItemCompanyModel.fromJson(Map<String, dynamic> json) {
    return ListedItemCompanyModel(
      id: _parseInt(json['id']),
      name: (json['name'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ListedCurrentStockModel {
  final int id;
  final int pharmacyId;
  final int productId;

  final int inStock;
  final int stockAlert;

  final num salePrice;
  final num discountPrice;
  final num peakHourPrice;
  final num mediboyOfferPrice;

  final String createdAt;
  final String updatedAt;

  const ListedCurrentStockModel({
    required this.id,
    required this.pharmacyId,
    required this.productId,
    required this.inStock,
    required this.stockAlert,
    required this.salePrice,
    required this.discountPrice,
    required this.peakHourPrice,
    required this.mediboyOfferPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  factory ListedCurrentStockModel.fromJson(Map<String, dynamic> json) {
    return ListedCurrentStockModel(
      id: _parseInt(json['id']),
      pharmacyId: _parseInt(json['pharmacy_id']),
      productId: _parseInt(json['product_id']),
      inStock: _parseInt(json['in_stock']),
      stockAlert: _parseInt(json['stock_alert']),
      salePrice: _parseNum(json['sale_price']),
      discountPrice: _parseNum(json['discount_price']),
      peakHourPrice: _parseNum(json['peak_hour_price']),
      mediboyOfferPrice: _parseNum(json['mediboy_offer_price']),
      createdAt: (json['created_at'] ?? '').toString(),
      updatedAt: (json['updated_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'pharmacy_id': pharmacyId,
    'product_id': productId,
    'in_stock': inStock,
    'stock_alert': stockAlert,
    'sale_price': salePrice,
    'discount_price': discountPrice,
    'peak_hour_price': peakHourPrice,
    'mediboy_offer_price': mediboyOfferPrice,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

/// ✅ matches each item in "data": []
class ListedItemModel {
  final int id;
  final String productName;
  final String genericName;

  final double retailMaxPrice;

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

  final ListedItemCompanyModel? company;
  final ListedCurrentStockModel? currentStock;

  const ListedItemModel({
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
    required this.company,
    required this.currentStock,
  });

  static num _parseNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    return num.tryParse(v.toString()) ?? 0;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  factory ListedItemModel.fromJson(Map<String, dynamic> json) {
    final companyJson = json['company'];
    final currentStockJson = json['current_stock'] ?? json['currentStock'];

    return ListedItemModel(
      id: _parseInt(json['id']),
      productName: (json['productName'] ?? '').toString(),
      genericName: (json['genericName'] ?? '').toString(),
      retailMaxPrice: _parseNum(json['retail_max_price']).toDouble(),
      cartQtyInc: _parseInt(json['cart_qty_inc']),
      cartText: (json['cart_text'] ?? '').toString(),
      unitInPack: (json['unit_in_pack'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      quantity: (json['quantity'] ?? '').toString(),
      prescription: (json['prescription'] ?? '').toString(),
      feature: (json['feature'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      coverImage: (json['coverImage'] ?? '').toString(),
      companyId: _parseInt(json['company_id']),
      categoryId: _parseInt(json['category_id']),
      productCoverImagePath: (json['product_cover_image_path'] ?? '')
          .toString(),
      company: companyJson is Map
          ? ListedItemCompanyModel.fromJson(
              Map<String, dynamic>.from(companyJson),
            )
          : null,
      currentStock: currentStockJson is Map
          ? ListedCurrentStockModel.fromJson(
              Map<String, dynamic>.from(currentStockJson),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productName': productName,
    'genericName': genericName,
    'retail_max_price': retailMaxPrice.toString(),
    'cart_qty_inc': cartQtyInc,
    'cart_text': cartText,
    'unit_in_pack': unitInPack,
    'type': type,
    'quantity': quantity,
    'prescription': prescription,
    'feature': feature,
    'status': status,
    'coverImage': coverImage,
    'company_id': companyId,
    'category_id': categoryId,
    'product_cover_image_path': productCoverImagePath,
    'company': company?.toJson(),
    'current_stock': currentStock?.toJson(),
  };

  /// UI helpers
  String get nameLine =>
      '$productName ${quantity.isEmpty ? '' : quantity}'.trim();
  bool get inStock => (currentStock?.inStock ?? 0) > 0;

  num get sale => currentStock?.discountPrice ?? 0;
  num get pSale => currentStock?.peakHourPrice ?? 0;
  num get offer => currentStock?.mediboyOfferPrice ?? 0;
}
