// lib/core/models/drug_item_model.dart

class DrugCategoryModel {
  final int id;
  final String name;

  const DrugCategoryModel({required this.id, required this.name});

  factory DrugCategoryModel.fromJson(Map<String, dynamic> json) {
    return DrugCategoryModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class DrugCompanyModel {
  final int id;
  final String name;

  const DrugCompanyModel({required this.id, required this.name});

  factory DrugCompanyModel.fromJson(Map<String, dynamic> json) {
    return DrugCompanyModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

/// ✅ API product model
class DrugItemModel {
  final int id;

  /// API: productName
  final String productName;

  final String genericName;

  /// API: retail_max_price (string)
  final num retailMaxPrice;

  /// API: unit_in_pack
  final String unitInPack;

  /// API: quantity (like "20 mg")
  final String strength;

  /// API: type (Capsule / Tablet / IV Injection etc)
  final String type;

  final String status;

  final String cartText;
  final String coverImage;

  final int categoryId;
  final int companyId;

  final String coverImagePath;

  final List<dynamic> images;

  final DrugCategoryModel? category;
  final DrugCompanyModel? company;

  const DrugItemModel({
    required this.id,
    required this.productName,
    required this.genericName,
    required this.retailMaxPrice,
    required this.unitInPack,
    required this.strength,
    required this.type,
    required this.status,
    required this.cartText,
    required this.coverImage,
    required this.categoryId,
    required this.companyId,
    required this.coverImagePath,
    required this.images,
    required this.category,
    required this.company,
  });

  factory DrugItemModel.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v;
      return num.tryParse(v.toString()) ?? 0;
    }

    return DrugItemModel(
      id: (json['id'] ?? 0) as int,
      productName: (json['productName'] ?? '') as String,
      genericName: (json['genericName'] ?? '') as String,
      retailMaxPrice: parseNum(json['retail_max_price']),
      unitInPack: (json['unit_in_pack'] ?? '') as String,
      strength: (json['quantity'] ?? '') as String,
      type: (json['type'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      cartText: (json['cart_text'] ?? '') as String,
      coverImage: (json['coverImage'] ?? '') as String,
      categoryId: (json['category_id'] ?? 0) as int,
      companyId: (json['company_id'] ?? 0) as int,
      coverImagePath: (json['product_cover_image_path'] ?? '') as String,
      images: (json['images'] as List?) ?? const [],
      category: json['category'] is Map<String, dynamic>
          ? DrugCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      company: json['company'] is Map<String, dynamic>
          ? DrugCompanyModel.fromJson(json['company'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productName': productName,
    'genericName': genericName,
    'retail_max_price': retailMaxPrice.toString(),
    'unit_in_pack': unitInPack,
    'quantity': strength,
    'type': type,
    'status': status,
    'cart_text': cartText,
    'coverImage': coverImage,
    'category_id': categoryId,
    'company_id': companyId,
    'product_cover_image_path': coverImagePath,
    'images': images,
    'category': category?.toJson(),
    'company': company?.toJson(),
  };

  /// ✅ helpers for your UI (to avoid changing view too much)
  String get nameLine =>
      '$productName ${strength.isEmpty ? '' : strength}'.trim();
  String get tag1 => type;
  String get tag2 => unitInPack;
  String get companyName => company?.name ?? '';

  /// ✅ handy: safely treat MRP as num (already num, but keep helper)
  num get mrp => retailMaxPrice;
}
