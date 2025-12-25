/// Types of failures that can occur in the Weather feature
enum WeatherFailureType {
  /// No internet connection
  network,

  /// Location or resource not found (404)
  notFound,

  /// server error (500, 502, etc.)
  serverError,

  /// API key issues or forbidden access (401, 403)
  unauthorized,

  /// Rate limiting (429)
  excessiveRequests,

  /// Data parsing errors
  invalidData,

  /// Unknown or unexpected error
  unknown,
}

/// Represents a failure in the Weather feature logic.
///
/// This class abstracts the underlying exception and provides a categorized
/// [type] that the UI can use to determine the appropriate user-facing message.
class WeatherFailure {
  final WeatherFailureType type;

  /// Optional technical message for logging/debugging (not for UI display).
  final String? devMessage;

  const WeatherFailure({required this.type, this.devMessage});

  @override
  String toString() => 'WeatherFailure(type: $type, devMessage: $devMessage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherFailure &&
        other.type == type &&
        other.devMessage == devMessage;
  }

  @override
  int get hashCode => type.hashCode ^ devMessage.hashCode;
}
