import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:intl/intl.dart';

class Formatters {
  /// Appends the temperature unit symbol to the value
  /// Input temperature is assumed to be in Kelvin (OpenWeather default)
  static String formatTemp(double temperatureInKelvin, TempUnit unit) {
    double temp;
    switch (unit) {
      case TempUnit.celsius:
        temp = kelvinToCelsius(temperatureInKelvin);
        break;
      case TempUnit.fahrenheit:
        temp = kelvinToFahrenheit(temperatureInKelvin);
        break;
    }
    return '${temp.round()}${unit.symbol}';
  }

  /// Appends the wind speed unit symbol to the value
  /// Input speed is assumed to be in m/s (OpenWeather default)
  static String formatWindSpeed(double speedInMps, WindSpeedUnit unit) {
    double speed;
    switch (unit) {
      case WindSpeedUnit.kmh:
        speed = speedInMps * 3.6;
        break;
      case WindSpeedUnit.mph:
        speed = speedInMps * 2.237;
        break;
      case WindSpeedUnit.mps:
        speed = speedInMps;
        break;
    }
    return '${speed.toStringAsFixed(1)} ${unit.symbol}';
  }

  /// Formats the wind speed and direction into a single string
  static String formatWindInfo(
    double? speed,
    double? direction,
    WindSpeedUnit unit,
  ) {
    if (speed == null) return 'N/A';

    final speedStr = formatWindSpeed(speed, unit);
    if (direction == null) return speedStr;

    return '${formatWindDirection(direction)} ~ $speedStr';
  }

  /// Returns the cardinal direction for a given degree (0-360)
  static String formatWindDirection(double? direction) {
    if (direction == null) return '';
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    // Normalize to 0-359
    final normalized = direction % 360;
    // Calculate index (each sector is 45 degrees, centered on the cardinal point)
    final index = ((normalized + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  /// Appends the pressure unit symbol.
  /// Note: Handles conversion for inHg/mb as OpenWeather returns hPa
  static String formatPressure(int pressure, PressureUnit unit) {
    switch (unit) {
      case PressureUnit.hpa:
        return '$pressure hPa';
      case PressureUnit.inHg:
        final inHg = pressure * 0.02953;
        return '${inHg.toStringAsFixed(2)} inHg';
      case PressureUnit.mb:
        return '$pressure mb';
    }
  }

  static String formatTimestamp(int? timestamp) {
    if (timestamp == null) return '--:--';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  // --- Utility conversion methods ---
  static double kelvinToCelsius(double k) => k - 273.15;
  static double kelvinToFahrenheit(double k) => (k - 273.15) * 9 / 5 + 32;
  static double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;
  static double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;
}
