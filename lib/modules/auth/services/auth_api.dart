import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/auth_storage.dart';
import '../login/models/login_models.dart';

class AuthApi {
  final Dio _dio;
  final AuthStorage _storage;

  AuthApi({Dio? dio, AuthStorage? storage})
    : _dio = dio ?? ApiClient.create(),
      _storage = storage ?? AuthStorage();

  Future<LoginResponse> login(LoginRequest req) async {
    try {
      final res = await _dio.post('/pharmacy/login', data: req.toJson());
      final data = res.data as Map<String, dynamic>;
      final parsed = LoginResponse.fromJson(data);

      await _storage.saveToken(parsed.token);
      await _storage.saveUser(parsed.user);

      return parsed;
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (_) {
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  Future<LogoutResponse> logout() async {
    try {
      final token = await _storage.readToken();
      if (token == null || token.isEmpty) {
        // already logged out
        await _storage.clearAll();
        return const LogoutResponse(message: 'Already logged out');
      }

      final res = await _dio.post(
        '/pharmacy/user_logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = res.data as Map<String, dynamic>;
      final parsed = LogoutResponse.fromJson(data);

      await _storage.clearAll();
      return parsed;
    } on DioException catch (e) {
      // even if API fails, clear local session to be safe
      await _storage.clearAll();
      throw _mapDioToApiException(e);
    } catch (_) {
      await _storage.clearAll();
      throw ApiException('Logout failed. Please try again.');
    }
  }

  ApiException _mapDioToApiException(DioException e) {
    final status = e.response?.statusCode;

    // server message if present
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
