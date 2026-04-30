import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(
    DioException error, {
    String defaultMessage = 'Request failed. Please try again.',
  }) {
    final status = error.response?.statusCode;
    final backendMessage = extractBackendMessage(error.response?.data);

    return ApiException(
      backendMessage ?? _fallbackMessageFor(error, defaultMessage),
      statusCode: status,
    );
  }

  static String? extractBackendMessage(dynamic data) {
    if (data is String) {
      return _cleanMessage(data);
    }

    if (data is! Map) return null;

    for (final key in const [
      'message',
      'msg',
      'error',
      'detail',
      'description',
    ]) {
      if (!data.containsKey(key)) continue;

      final message = _joinMessages(
        _extractMessageValues(data[key], readMapValues: true),
      );
      if (message != null) return message;
    }

    if (data.containsKey('errors')) {
      return _joinMessages(
        _extractMessageValues(data['errors'], readMapValues: true),
      );
    }

    return null;
  }

  static Iterable<String> _extractMessageValues(
    dynamic data, {
    required bool readMapValues,
  }) sync* {
    if (data == null) return;

    if (data is String) {
      final text = _cleanMessage(data);
      if (text != null) yield text;
      return;
    }

    if (data is List) {
      for (final item in data) {
        yield* _extractMessageValues(item, readMapValues: true);
      }
      return;
    }

    if (data is Map) {
      for (final key in const [
        'message',
        'msg',
        'error',
        'detail',
        'description',
      ]) {
        if (data.containsKey(key)) {
          yield* _extractMessageValues(data[key], readMapValues: true);
        }
      }

      if (data.containsKey('errors')) {
        yield* _extractMessageValues(data['errors'], readMapValues: true);
      }

      if (readMapValues) {
        for (final value in data.values) {
          yield* _extractMessageValues(value, readMapValues: true);
        }
      }
    }
  }

  static String? _joinMessages(Iterable<String> values) {
    final unique = <String>[];
    for (final value in values) {
      final text = value.trim();
      if (text.isNotEmpty && !unique.contains(text)) {
        unique.add(text);
      }
    }

    if (unique.isEmpty) return null;
    return unique.join('\n');
  }

  static String? _cleanMessage(String value) {
    final text = value.trim();
    if (text.isEmpty || text.startsWith('<')) return null;
    return text;
  }

  static String _fallbackMessageFor(
    DioException error,
    String defaultMessage,
  ) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Connection timed out. Please try again.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'No internet connection. Please try again.';
    }

    return defaultMessage;
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
