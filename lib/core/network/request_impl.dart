import 'package:dio/dio.dart';
import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/core/foundation/errors.dart';
import 'package:flutter_template/core/network/network_client.dart';

/// API 响应格式适配层
///
/// 默认格式：
/// ```json
/// { "code": "200", "data": { ... }, "message": "success" }
/// ```
/// TODO: 根据你的后端 API 响应格式修改此文件
class RequestImpl {
  RequestImpl._();

  static Dio createAppRequest() {
    return NetworkClient.instance.dio;
  }

  @pragma('vm:prefer-inline')
  static Result<T> generalHandler<T>(
    Response<dynamic> response,
    T Function(dynamic data) convert,
  ) {
    final raw = response.data;
    final data = raw is Map ? Map<String, dynamic>.from(raw) : null;

    if (response.statusCode != 200) {
      final backendCode = data == null ? null : _extractCode(data);
      final backendMessage = data == null ? null : _extractErrorMessage(data);
      return Result.failure(
        ServerFailure(
          code: backendCode ?? response.statusCode?.toString() ?? 'UNKNOWN',
          message: backendMessage ?? '服务器错误',
          statusCode: response.statusCode,
          data: data ?? raw,
        ),
      );
    }

    if (data == null) {
      return Result.failure(
        const ServerFailure(code: 'INVALID_RESPONSE', message: '响应格式错误'),
      );
    }

    final code = _extractCode(data) ?? '';
    final isSuccess = _isBusinessSuccess(data, code);

    if (!isSuccess) {
      final message = _extractErrorMessage(data);
      return Result.failure(
        ServerFailure(
          code: code.isEmpty ? 'UNKNOWN' : code,
          message: message ?? '请求失败',
          data: data,
        ),
      );
    }

    try {
      // TODO: 根据你的 API 响应结构修改数据提取字段（默认为 "model"）
      final model = convert(data['model']);
      return Result.success(model);
    } catch (error, stackTrace) {
      return Result.failure(
        ServerFailure(
          code: 'DATA_PARSE_ERROR',
          message: '数据解析失败: $error',
          stackTrace: stackTrace,
        ),
      );
    }
  }

  static bool _isBusinessSuccess(Map<String, dynamic> data, String code) {
    final succeed = data['succeed'];
    if (succeed is bool) return succeed;
    if (succeed is num) return succeed == 1;
    if (succeed is String) {
      final normalized = succeed.toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return code == '200';
  }

  static String? _extractCode(Map<String, dynamic> data) {
    final code = data['code'];
    if (code != null) {
      final value = '$code'.trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  static String? _extractErrorMessage(Map<String, dynamic> data) {
    final errorNode = data['error'];
    if (errorNode is Map) {
      final value = errorNode['msg'];
      if (value is String && value.isNotEmpty) return value;
    }

    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;

    final msg = data['msg'];
    if (msg is String && msg.isNotEmpty) return msg;

    return null;
  }
}
