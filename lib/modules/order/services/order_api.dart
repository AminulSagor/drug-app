import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../models/order_with_details_response_model.dart';
import '../models/search_order_response_model.dart';

class OrderApi {
  final Dio _dio;

  /// ✅ ApiClient.create() should attach token every call (same as other APIs)
  OrderApi({Dio? dio}) : _dio = dio ?? ApiClient.create();

  Future<OrderWithDetailsResponseModel> getOrdersWithDetails({
    required int page,
  }) async {
    try {
      final res = await _dio.get(
        '/pharmacy/get_order_with_details-for-mobile-app',
        queryParameters: {'page': page},
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Unexpected response from server.');
      }

      return OrderWithDetailsResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// ✅ Search order by order number
  /// Api: /pharmacy/search_order-for-mobile-app?orderNumber=integernumber
  Future<List<OrderWithDetailsModel>> searchOrdersByOrderNumber({
    required int orderNumber,
  }) async {
    try {
      final res = await _dio.get(
        '/pharmacy/search_order-for-mobile-app',
        queryParameters: {'orderNumber': orderNumber},
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Unexpected response from server.');
      }

      final parsed = SearchOrderResponseModel.fromJson(data);
      return parsed.orders;
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// ✅ NEW: Clear order (rider/customer)
  /// Api: {base_url}/pharmacy/clear_order-for-mobile-app
  /// Method: POST
  /// Payload: {"order_id":157}
  Future<String> clearOrder({required int orderId}) async {
    try {
      final res = await _dio.post(
        '/pharmacy/clear_order-for-mobile-app',
        data: {'order_id': orderId},
      );

      final data = res.data;

      // ✅ Try to get message if backend returns one
      if (data is Map<String, dynamic>) {
        final m = data['message'];
        if (m is String && m.trim().isNotEmpty) return m.trim();
      }

      return 'Order cleared successfully.';
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
