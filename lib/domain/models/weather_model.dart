import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? cityName;

  @HiveField(2)
  final String? country;

  @HiveField(3)
  final double? temperature;

  @HiveField(4)
  final double? feelsLike;

  @HiveField(5)
  final double? minTemp;

  @HiveField(6)
  final double? maxTemp;

  @HiveField(7)
  final String? condition;

  @HiveField(8)
  final String? description;

  @HiveField(9)
  final String? iconCode;

  @HiveField(10)
  final int? humidity;

  @HiveField(11)
  final double? windSpeed;

  @HiveField(12)
  final int? visibility;

  @HiveField(13)
  final int? pressure;

  @HiveField(14)
  final int? sunrise;

  @HiveField(15)
  final int? sunset;

  @HiveField(16)
  final int? timestamp;

  @HiveField(17)
  final double? latitude;

  @HiveField(18)
  final double? longitude;

  @HiveField(19)
  final DateTime fetchedAt;

  @HiveField(20)
  final int? cloudiness;

  @HiveField(21)
  final int? seaLevel;

  @HiveField(22)
  final int? grndLevel;

  WeatherModel({
    required this.id,
    this.cityName,
    this.country,
    this.temperature,
    this.feelsLike,
    this.minTemp,
    this.maxTemp,
    this.condition,
    this.description,
    this.iconCode,
    this.humidity,
    this.windSpeed,
    this.visibility,
    this.pressure,
    this.sunrise,
    this.sunset,
    this.timestamp,
    this.latitude,
    this.longitude,
    required this.fetchedAt,
    this.cloudiness,
    this.seaLevel,
    this.grndLevel,
  });

  WeatherModel copyWith({
    int? id,
    String? cityName,
    String? country,
    double? temperature,
    double? feelsLike,
    double? minTemp,
    double? maxTemp,
    String? condition,
    String? description,
    String? iconCode,
    int? humidity,
    double? windSpeed,
    int? visibility,
    int? pressure,
    int? sunrise,
    int? sunset,
    int? timestamp,
    double? latitude,
    double? longitude,
    DateTime? fetchedAt,
    int? cloudiness,
    int? seaLevel,
    int? grndLevel,
  }) {
    return WeatherModel(
      id: id ?? this.id,
      cityName: cityName ?? this.cityName,
      country: country ?? this.country,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      visibility: visibility ?? this.visibility,
      pressure: pressure ?? this.pressure,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      cloudiness: cloudiness ?? this.cloudiness,
      seaLevel: seaLevel ?? this.seaLevel,
      grndLevel: grndLevel ?? this.grndLevel,
    );
  }

  /// Factory constructor to create a WeatherModel from OpenWeather API JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final weatherList = json['weather'] as List?;
    final weather = (weatherList != null && weatherList.isNotEmpty)
        ? weatherList[0]
        : <String, dynamic>{};
    final main = json['main'] as Map<String, dynamic>? ?? {};
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};
    final coord = json['coord'] as Map<String, dynamic>? ?? {};
    final clouds = json['clouds'] as Map<String, dynamic>? ?? {};

    return WeatherModel(
      id: json['id'] ?? 0,
      cityName: json['name'],
      country: sys['country'],
      temperature: (main['temp'] as num?)?.toDouble(),
      feelsLike: (main['feels_like'] as num?)?.toDouble(),
      minTemp: (main['temp_min'] as num?)?.toDouble(),
      maxTemp: (main['temp_max'] as num?)?.toDouble(),
      condition: weather['main'],
      description: weather['description'],
      iconCode: weather['icon'],
      humidity: main['humidity'],
      windSpeed: (wind['speed'] as num?)?.toDouble(),
      visibility: json['visibility'],
      pressure: main['pressure'],
      sunrise: sys['sunrise'],
      sunset: sys['sunset'],
      timestamp: json['dt'],
      latitude: (coord['lat'] as num?)?.toDouble(),
      longitude: (coord['lon'] as num?)?.toDouble(),
      fetchedAt: DateTime.now(),
      cloudiness: clouds['all'],
      seaLevel: main['sea_level'],
      grndLevel: main['grnd_level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': cityName,
      'sys': {'country': country, 'sunrise': sunrise, 'sunset': sunset},
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': minTemp,
        'temp_max': maxTemp,
        'humidity': humidity,
        'pressure': pressure,
        'sea_level': seaLevel,
        'grnd_level': grndLevel,
      },
      'weather': [
        {'main': condition, 'description': description, 'icon': iconCode},
      ],
      'wind': {'speed': windSpeed},
      'visibility': visibility,
      'dt': timestamp,
      'coord': {'lat': latitude, 'lon': longitude},
      'fetchedAt': fetchedAt.toIso8601String(),
      'clouds': {'all': cloudiness},
    };
  }
}
