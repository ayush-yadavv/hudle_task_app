/// global configuration constants for the application.
class AppConfigs {
  AppConfigs._();

  /// Current version of the application.
  static String apkVersion = '0.0.1';

  /// Human-readable name of the application.
  static const String applicationName = 'Weather App';

  /// Default city to fetch weather for if no location is selected.
  // static const String defaultCity = 'Delhi';

  /// Short description or footer message for the app.
  static const String appDescription = 'Thanks 🍻';

  /// Generates the full weather API endpoint URL for the default city.
  static String getWeatherEndpoint(String apiKey) {
    return 'https://api.openweathermap.org/data/2.5/weather?q=Delhi&appid=$apiKey&units=metric';
  }
}
