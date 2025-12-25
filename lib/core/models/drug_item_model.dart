class DrugItemModel {
  final String id;

  /// Product description (like: Sergel 20mg)
  final String name;

  /// Tag 1 (like: Capsule)
  final String type;

  /// Tag 2 (like: 10 capsule in a strip)
  final String pack;

  /// Rate section
  final num sale;
  final num pSale;
  final num offer;

  /// Stock quantity
  final int quantity;

  const DrugItemModel({
    required this.id,
    required this.name,
    required this.type,
    required this.pack,
    required this.sale,
    required this.pSale,
    required this.offer,
    required this.quantity,
  });

  bool get inStock => quantity > 0;

  DrugItemModel copyWith({
    String? id,
    String? name,
    String? type,
    String? pack,
    num? sale,
    num? pSale,
    num? offer,
    int? quantity,
  }) {
    return DrugItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      pack: pack ?? this.pack,
      sale: sale ?? this.sale,
      pSale: pSale ?? this.pSale,
      offer: offer ?? this.offer,
      quantity: quantity ?? this.quantity,
    );
  }
}
