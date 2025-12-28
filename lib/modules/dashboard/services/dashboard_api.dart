import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../models/dashboard_response_model.dart';

class DashboardApi {
  final Dio _dio;

  DashboardApi({Dio? dio}) : _dio = dio ?? ApiClient.create();

  Future<DashboardResponseModel> getDashboardData() async {
    try {
      final res = await _dio.get('/pharmacy/get_dashboard_data-for-mobile-app');

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Unexpected response from server.');
      }

      return DashboardResponseModel.fromJson(data);
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// ✅ Accept / Decline order
  /// Action_value: 0 decline, 1 accept
  Future<void> acceptDeclineOrder({
    required int orderId,
    required int actionValue,
  }) async {
    try {
      final res = await _dio.post(
        '/pharmacy/accept_decline_order-for-mobile-app',
        data: {
          "order_id": orderId,
          "Action_value": actionValue, // keep exact key casing
        },
      );

      // optional validation (don’t fail if backend returns plain text)
      if (res.statusCode != null && res.statusCode! >= 400) {
        throw ApiException('Request failed. Please try again.');
      }
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
