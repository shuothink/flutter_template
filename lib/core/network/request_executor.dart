import 'package:dio/dio.dart';
import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/core/foundation/errors.dart';
import 'package:flutter_template/core/network/request_impl.dart';

class RequestExecutor {
  const RequestExecutor();

  Future<Result<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) convert,
  }) async {
    try {
      final response = await RequestImpl.createAppRequest().get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return RequestImpl.generalHandler(response, convert);
    } on DioException catch (error, stackTrace) {
      return Result.failure(_mapDioError(error, stackTrace));
    } catch (error, stackTrace) {
      return Result.failure(
        UnexpectedFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }

  Future<Result<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) convert,
  }) async {
    try {
      final response = await RequestImpl.createAppRequest().post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return RequestImpl.generalHandler(response, convert);
    } on DioException catch (error, stackTrace) {
      return Result.failure(_mapDioError(error, stackTrace));
    } catch (error, stackTrace) {
      return Result.failure(
        UnexpectedFailure(message: error.toString(), stackTrace: stackTrace),
      );
    }
  }

  Failure _mapDioError(DioException error, StackTrace stackTrace) {
    final statusCode = error.response?.statusCode;
    final backendData = _asMap(error.response?.data);
    final backendCode = _extractBackendCode(backendData);
    final backendMessage = _extractBackendMessage(backendData);
    final message = backendMessage ?? error.message ?? '网络请求失败';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          code: 'TIMEOUT',
          message: '网络超时',
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        if (statusCode != null) {
          return ServerFailure(
            code: backendCode ?? statusCode.toString(),
            message: message,
            statusCode: statusCode,
            data: backendData ?? error.response?.data,
            stackTrace: stackTrace,
          );
        }
        return NetworkFailure(
          code: backendCode ?? 'BAD_RESPONSE',
          message: message,
          data: backendData ?? error.response?.data,
          stackTrace: stackTrace,
        );

      case DioExceptionType.cancel:
        return NetworkFailure(
          code: 'CANCELLED',
          message: '请求已取消',
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          code: 'CONNECTION_ERROR',
          message: '网络连接失败',
          stackTrace: stackTrace,
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          code: 'BAD_CERTIFICATE',
          message: '证书错误',
          stackTrace: stackTrace,
        );

      case DioExceptionType.unknown:
        return NetworkFailure(
          code: 'UNKNOWN',
          message: message,
          stackTrace: stackTrace,
        );
    }
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  String? _extractBackendCode(Map<String, dynamic>? data) {
    if (data == null) return null;
    final code = data['code'];
    if (code == null) return null;
    final value = '$code'.trim();
    return value.isEmpty ? null : value;
  }

  String? _extractBackendMessage(Map<String, dynamic>? data) {
    if (data == null) return null;

    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;

    final msg = data['msg'];
    if (msg is String && msg.isNotEmpty) return msg;

    final errorNode = data['error'];
    if (errorNode is Map) {
      final nestedMsg = errorNode['msg'];
      if (nestedMsg is String && nestedMsg.isNotEmpty) return nestedMsg;
    }

    return null;
  }
}
