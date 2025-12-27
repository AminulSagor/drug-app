import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../storage/auth_storage.dart';

class ApiClient {
  ApiClient._();

  static Dio create({AuthStorage? storage}) {
    final baseUrl = dotenv.get('BASE_URL');
    final authStorage = storage ?? AuthStorage();

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // ✅ do NOT attach token for login
          final isLogin = options.path.endsWith('/pharmacy/login');

          if (!isLogin) {
            final token = await authStorage.readToken();
            if (token != null && token.trim().isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}
