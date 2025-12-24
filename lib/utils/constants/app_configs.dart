class AppConfigs {
  AppConfigs._();

  static String apkVersion = '0.0.1';
  static const String applicationName = 'Weather App';
  static const String defaultCity = 'Delhi';
  static const String appDescription = 'Thanks 🍻';
  static String getWeatherEndpoint(String apiKey) {
    return 'https://api.openweathermap.org/data/2.5/weather?q=Delhi&appid=$apiKey&units=metric';
  }
}
