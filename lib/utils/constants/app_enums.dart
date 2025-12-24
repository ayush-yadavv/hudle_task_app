enum TextSizes { small, medium, large }

enum TempUnit {
  celsius('°C'),
  fahrenheit('°F');

  final String symbol;

  const TempUnit(this.symbol);

  String get toApiString => this == TempUnit.celsius ? 'metric' : 'imperial';
}

enum WindSpeedUnit {
  kmh('km/h'),
  mps('m/s'),
  mph('mph');

  final String symbol;

  const WindSpeedUnit(this.symbol);
}

//pressure unit
enum PressureUnit {
  hpa('hPa'),
  inHg('inHg'),
  mb('mb');

  final String symbol;

  const PressureUnit(this.symbol);
}

/// Theme mode enum for app appearance settings
enum AppThemeMode {
  system('System Default'),
  light('Light'),
  dark('Dark');

  final String label;

  const AppThemeMode(this.label);
}
