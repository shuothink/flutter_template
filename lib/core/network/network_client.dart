import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_template/core/foundation/logger.dart';

class NetworkClient {
  NetworkClient._();

  static final NetworkClient instance = NetworkClient._();

  /// Token 过期的业务码，根据后端约定配置
  static const Set<String> _tokenExpiredCodes = <String>{
    // TODO: 添加你的 token 过期业务码
  };

  Dio? _dio;
  String? Function()? _tokenProvider;
  String? Function()? _deviceIdProvider;
  void Function()? _onUnauthorized;

  Dio get dio {
    final client = _dio;
    if (client == null) {
      throw StateError(
        'NetworkClient is not initialized. Call initialize() before use.',
      );
    }
    return client;
  }

  void initialize({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    String? Function()? tokenProvider,
    String? Function()? deviceIdProvider,
    void Function()? onUnauthorized,
  }) {
    _tokenProvider = tokenProvider;
    _deviceIdProvider = deviceIdProvider;
    _onUnauthorized = onUnauthorized;

    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    final client = Dio(options);
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenProvider?.call();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          final deviceId = _deviceIdProvider?.call();
          if (deviceId != null && deviceId.isNotEmpty) {
            options.headers['X-Device-ID'] = deviceId;
          }

          options.headers['X-Request-Time'] = DateTime.now()
              .millisecondsSinceEpoch
              .toString();
          handler.next(options);
        },
        onResponse: (response, handler) {
          final data = response.data;
          if (data is Map<String, dynamic>) {
            final code = _extractBackendCode(data);
            if (code != null && _tokenExpiredCodes.contains(code)) {
              AppLogger.w(
                'Received unauthorized business code: $code',
                tag: 'network',
              );
              _onUnauthorized?.call();
            }
          }
          handler.next(response);
        },
        onError: (error, handler) {
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            AppLogger.w('Received 401 unauthorized', tag: 'network');
            _onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      client.interceptors.add(AppLogger.dioLogger());
    }

    _dio = client;
    AppLogger.i('Network client initialized: $baseUrl', tag: 'network');
  }

  String? _extractBackendCode(Map<String, dynamic> data) {
    final rawCode = data['code'] ?? data['errCode'];
    if (rawCode == null) return null;
    final code = '$rawCode'.trim();
    return code.isEmpty ? null : code;
  }
}
