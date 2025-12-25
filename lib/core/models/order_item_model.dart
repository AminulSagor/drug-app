import 'drug_item_model.dart';

class OrderItemModel {
  final DrugItemModel drug;
  final int quantity;
  final num rate;

  const OrderItemModel({
    required this.drug,
    required this.quantity,
    required this.rate,
  });

  num get total => rate * quantity;
}
