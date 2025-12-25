import 'package:flutter/material.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_failure.dart';

extension WeatherFailureExtension on WeatherFailure {
  /// Returns a user-friendly error message based on the failure type.
  ///
  /// The [context] is accepted for future localization support,
  /// even if strictly not used with simple strings currently.
  String getUserMessage(BuildContext context) {
    switch (type) {
      case WeatherFailureType.network:
        return 'No internet connection. Please check your network settings.';
      case WeatherFailureType.notFound:
        return 'Location not found. Please check the spelling.';
      case WeatherFailureType.serverError:
        return 'Server error. Please try again later.';
      case WeatherFailureType.unauthorized:
        return 'Authorization failed. API key may be invalid.';
      case WeatherFailureType.excessiveRequests:
        return 'Too many requests. Please wait a moment.';
      case WeatherFailureType.invalidData:
        return 'Data error. Received invalid weather data.';
      case WeatherFailureType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }
}
