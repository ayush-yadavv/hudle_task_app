import 'package:dio/dio.dart';
import 'package:hudle_task_app/utils/exceptions/api_exception.dart';
import 'package:hudle_task_app/utils/logger/logger.dart';

/// A wrapper around the Dio package to handle HTTP requests.
///
/// Provides a simplified interface for common HTTP methods (GET, POST, PUT, DELETE)
/// and centralized error handling for Dio-specific exceptions.
class DioClient {
  final Dio _dio;

  DioClient(this._dio);

  /// Performs an HTTP GET request.
  ///
  /// [endpoint] is the path or URL.
  /// [queryParameters] are optional key-value pairs to append to the URL.
  /// [options] allow for additional request configuration.
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  /// Performs an HTTP POST request.
  Future<dynamic> post(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  /// Performs an HTTP PUT request.
  Future<dynamic> put(
    String endpoint,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  /// Performs an HTTP DELETE request.
  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.delete(
      endpoint,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  /// Converts a [DioException] into a domain-specific [ApiException].
  ApiException handleDioError(DioException error) {
    String errorType;
    String message;
    int? statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorType = 'connection_timeout';
        message = 'Connection timeout';
        break;

      case DioExceptionType.connectionError:
        errorType = 'connection_error';
        message = 'Connection failed';
        break;

      case DioExceptionType.badResponse:
        errorType = 'bad_response';
        statusCode = error.response?.statusCode;
        message =
            error.response?.data['message'] ??
            'Server error: ${error.response?.statusCode}';
        break;

      case DioExceptionType.cancel:
        errorType = 'cancelled';
        message = 'Request cancelled';
        break;

      default:
        errorType = 'unknown';
        message = 'An unexpected error occurred';
    }

    TLogger.error('DioException Handled: $errorType - $message', error: error);

    return ApiException(
      message: message,
      statusCode: statusCode,
      errorType: errorType,
    );
  }
}
