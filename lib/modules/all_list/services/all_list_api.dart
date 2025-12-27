import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../models/bill_mode_models.dart';
import '../models/listed_item_model.dart';

class CurrentStockPage {
  final int currentPage;
  final List<ListedItemModel> data;
  final int from;
  final int to;
  final int lastPage;
  final int perPage;
  final int total;

  const CurrentStockPage({
    required this.currentPage,
    required this.data,
    required this.from,
    required this.to,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory CurrentStockPage.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List?) ?? const [];
    return CurrentStockPage(
      currentPage: (json['current_page'] ?? 1) as int,
      data: list
          .whereType<Map<String, dynamic>>()
          .map((e) => ListedItemModel.fromJson(e))
          .toList(),
      from: (json['from'] ?? 0) as int,
      to: (json['to'] ?? 0) as int,
      lastPage: (json['last_page'] ?? 1) as int,
      perPage: (json['per_page'] ?? 20) is int
          ? (json['per_page'] ?? 20) as int
          : int.tryParse('${json['per_page']}') ?? 20,
      total: (json['total'] ?? 0) as int,
    );
  }
}

class CurrentStockResponse {
  final CurrentStockPage currentStock;

  const CurrentStockResponse({required this.currentStock});

  factory CurrentStockResponse.fromJson(Map<String, dynamic> json) {
    final cs = json['currentStock'];
    if (cs is! Map<String, dynamic>) {
      return const CurrentStockResponse(
        currentStock: CurrentStockPage(
          currentPage: 1,
          data: [],
          from: 0,
          to: 0,
          lastPage: 1,
          perPage: 20,
          total: 0,
        ),
      );
    }

    return CurrentStockResponse(currentStock: CurrentStockPage.fromJson(cs));
  }
}

class AllListApi {
  final Dio _dio;

  AllListApi({Dio? dio}) : _dio = dio ?? ApiClient.create();

  Future<BillModeResponse> getCurrentBillMode() async {
    try {
      final res = await _dio.get(
        '/pharmacy/get_current_bill_mode-for-mobile-app',
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Unexpected response from server.');
      }

      return BillModeResponse.fromJson(data);
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<UpdateBillModeResponse> updateBillMode({required int billMode}) async {
    try {
      final res = await _dio.post(
        '/pharmacy/update_bill_mode-for-mobile-app',
        data: {'bill_mode': billMode},
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        return const UpdateBillModeResponse(
          message: 'Bill mode updated',
          status: 'success',
        );
      }

      return UpdateBillModeResponse.fromJson(data);
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// ✅ 1) Get all current stock (paginated)
  Future<CurrentStockResponse> getAllCurrentStock({int page = 1}) async {
    try {
      final res = await _dio.get(
        '/pharmacy/get_all_current_stock_with_product_deatails-for-mobile-app',
        queryParameters: {'page': page},
      );

      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw ApiException('Unexpected response from server.');
      }

      return CurrentStockResponse.fromJson(data);
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// ✅ 2) Search current stock product (non-paginated list)
  Future<List<ListedItemModel>> searchCurrentProduct({
    required String query,
  }) async {
    try {
      final res = await _dio.get(
        '/pharmacy/search_current_product-for-mobile-app',
        queryParameters: {'productName': query},
      );

      final data = res.data;
      if (data is! List) {
        throw ApiException('Unexpected response from server.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => ListedItemModel.fromJson(e))
          .toList();
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
