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
  Future<String> acceptDeclineOrder({
    required int orderId,
    required int actionValue,
  }) async {
    try {
      final res = await _dio.post(
        '/pharmacy/accept_decline_order-for-mobile-app',
        data: {"order_id": orderId, "action_value": actionValue},
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Unexpected response from server.');
      }

      final msg =
          _extractApiMessage(data) ??
          (actionValue == 1
              ? 'Order confirmed successfully'
              : 'Order declined successfully');

      final hasStatus = data.containsKey('status');
      if (hasStatus && !_isSuccessStatus(data['status'])) {
        throw ApiException(msg);
      }

      return msg;
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  ApiException _mapDioToApiException(DioException e) {
    return ApiException.fromDio(e);
  }

  String? _extractApiMessage(Map<String, dynamic> data) {
    final message = data['message'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final msg = data['msg'];
    if (msg is String && msg.trim().isNotEmpty) {
      return msg.trim();
    }

    return null;
  }

  bool _isSuccessStatus(dynamic status) {
    if (status is bool) return status;
    if (status is num) return status == 1;
    if (status is String) {
      final normalized = status.trim().toLowerCase();
      return normalized == 'success' ||
          normalized == 'ok' ||
          normalized == 'true' ||
          normalized == '1';
    }

    return false;
  }
}
