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
      await _storage.clearAll();
      throw _mapDioToApiException(e);
    } catch (_) {
      await _storage.clearAll();
      throw ApiException('Logout failed. Please try again.');
    }
  }

  // ============================================================
  // ✅ RESET PASSWORD APIs (NOW RETURNS MESSAGE)
  // ============================================================

  String _extractMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        final m = data['message'];
        if (m is String && m.trim().isNotEmpty) return m.trim();
      }
      if (data is String && data.trim().isNotEmpty) return data.trim();
    } catch (_) {}
    return '';
  }

  /// Sent OTP API : /pharmacy/send_otp
  /// Payload : {"number":"01616815056"}
  Future<String> sendOtp({required String number}) async {
    try {
      final res = await _dio.post(
        '/pharmacy/send_otp',
        data: {'number': number},
      );
      final msg = _extractMessage(res.data);
      return msg.isNotEmpty ? msg : 'OTP sent';
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (e) {
      dev.log('sendOtp error', error: e);
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// Verify OTP API : /pharmacy/verify_otp
  /// Payload : {"number":"01616815056","otp":1234}
  Future<String> verifyOtp({required String number, required int otp}) async {
    try {
      final res = await _dio.post(
        '/pharmacy/verify_otp',
        data: {'number': number, 'otp': otp},
      );
      final msg = _extractMessage(res.data);
      return msg.isNotEmpty ? msg : 'OTP verified';
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (e) {
      dev.log('verifyOtp error', error: e);
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  /// Password Reset API : /pharmacy/password_reset
  /// Payload : {"phoneNumber":"01616815056","otp":1234,"password":"xxxxxx"}
  Future<String> passwordReset({
    required String phoneNumber,
    required int otp,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        '/pharmacy/password_reset',
        data: {'phoneNumber': phoneNumber, 'otp': otp, 'password': password},
      );
      final msg = _extractMessage(res.data);
      return msg.isNotEmpty ? msg : 'Password changed';
    } on DioException catch (e) {
      throw _mapDioToApiException(e);
    } on SocketException {
      throw ApiException('No internet connection. Please try again.');
    } catch (e) {
      dev.log('passwordReset error', error: e);
      throw ApiException('Something went wrong. Please try again.');
    }
  }

  // ============================================================

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
