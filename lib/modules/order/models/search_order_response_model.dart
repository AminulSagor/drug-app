import 'order_with_details_response_model.dart';

class SearchOrderResponseModel {
  final List<OrderWithDetailsModel> orders;

  const SearchOrderResponseModel({required this.orders});

  factory SearchOrderResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['orders'];

    final list = (raw is List)
        ? raw
              .where((e) => e is Map<String, dynamic>)
              .map(
                (e) =>
                    OrderWithDetailsModel.fromJson(e as Map<String, dynamic>),
              )
              .toList()
        : <OrderWithDetailsModel>[];

    return SearchOrderResponseModel(orders: list);
  }
}
