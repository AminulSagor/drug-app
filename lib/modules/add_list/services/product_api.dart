import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/models/drug_item_model.dart';

class ProductApi {
  final Dio _dio;

  ProductApi({Dio? dio}) : _dio = dio ?? ApiClient.create();

  Future<List<DrugItemModel>> searchProducts(String query) async {
    try {
      final res = await _dio.get(
        '/pharmacy/product/search',
        queryParameters: {'productName': query},
      );

      final data = res.data;
      if (data is! List) throw ApiException('Unexpected response from server.');

      return data
          .whereType<Map<String, dynamic>>()
          .map(DrugItemModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// ✅ Add Stock (Add/Update)
  Future<AddUpdateItemResponse> addOrUpdateProductList(
    AddUpdateItemRequest req,
  ) async {
    try {
      final res = await _dio.post(
        '/pharmacy/add-update-stock-for-mobile-app',
        data: req.toJson(),
      );

      final data = res.data;
      if (data is Map<String, dynamic>) {
        return AddUpdateItemResponse.fromJson(data);
      }

      // you said: assume response like { "message": "Item added successfully" }
      return const AddUpdateItemResponse(message: 'Item added successfully');
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  ApiException _mapDioToApiException(DioException e) {
    final status = e.response?.statusCode;

    String msg = 'Request failed. Please try again.';
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final m = data['message'];
      if (m is String && m.trim().isNotEmpty) msg = m;
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      msg = 'Connection timed out. Please try again.';
    }

    return ApiException(msg, statusCode: status);
  }
}

/// ---------------- MODELS ----------------

class AddUpdateItemRequest {
  final int productId;
  final num stockMrp;
  final num discountPrice; // sale
  final num peakHourPrice; // p-sale
  final num offerPrice; // m-offer
  final int qty; // max-acpt qty

  const AddUpdateItemRequest({
    required this.productId,
    required this.stockMrp,
    required this.discountPrice,
    required this.peakHourPrice,
    required this.offerPrice,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "stock_mrp": stockMrp,
    "discount_price": discountPrice,
    "peak_hour_price": peakHourPrice,
    "offer_price": offerPrice,
    "qty": qty,
  };
}

class AddUpdateItemResponse {
  final String message;

  const AddUpdateItemResponse({required this.message});

  factory AddUpdateItemResponse.fromJson(Map<String, dynamic> json) {
    return AddUpdateItemResponse(message: (json['message'] ?? '').toString());
  }
}
