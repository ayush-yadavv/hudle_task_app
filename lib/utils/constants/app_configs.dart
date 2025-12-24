class AppConfigs {
  AppConfigs._();

  static String apkVersion = '0.0.1';
  static const String applicationName = 'Hudle Weather App';
  static String getWeatherEndpoint(String apiKey) {
    return 'https://api.openweathermap.org/data/2.5/weather?q=Delhi&appid=$apiKey&units=metric';
  }
}
