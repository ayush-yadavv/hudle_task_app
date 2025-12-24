/// Custom exception class for API-related errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorType;

  ApiException({required this.message, this.statusCode, this.errorType});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException: $message (Status Code: $statusCode)';
    }
    return 'ApiException: $message';
  }

  /// User-friendly error message
  String get userMessage {
    switch (errorType) {
      case 'connection_timeout':
        return 'Connection timeout. Please check your internet connection.';
      case 'connection_error':
        return 'Unable to connect. Please check your internet connection.';
      case 'bad_response':
        if (statusCode == 404) {
          return 'Location not found. Please try a different search.';
        } else if (statusCode == 401) {
          return 'Authentication failed. Please check API key.';
        } else if (statusCode == 429) {
          return 'Too many requests. Please try again later.';
        }
        return 'Server error. Please try again later.';
      case 'invalid_data':
        return 'Invalid data received. Please try again.';
      case 'not_found':
        return 'Location not found. Please check the name and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
