import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends HiveObject {
  @HiveField(0)
  //id of the generation
  final int id;

  @HiveField(1)
  //name of the station
  final String? stationName;

  @HiveField(25)
  //name of the geolocation
  final String? geolocationName;

  @HiveField(26)
  //name of the country
  final String? country;

  @HiveField(3)
  //major temperature in kelvin
  final double? temperature;

  @HiveField(4)
  // feels like temp in kelvin
  final double? feelsLike;

  @HiveField(5)
  // min temp
  final double? minTemp;

  @HiveField(6)
  //max temp
  final double? maxTemp;

  @HiveField(7)
  //keyword of the weather condition
  final String? condition;

  @HiveField(8)
  //description of the weather condition
  final String? description;

  @HiveField(9)
  //icon code of the weather condition
  final String? iconCode;

  @HiveField(10)
  //humidity
  final int? humidity;

  @HiveField(11)
  //windspeed
  final double? windSpeed;

  @HiveField(12)
  //wind direction
  final double? windDeg;

  @HiveField(13)
  //visibilty
  final int? visibility;

  @HiveField(14)
  //atm-pressure
  final int? pressure;

  @HiveField(15)
  //sunrise
  final int? sunrise;

  @HiveField(16)
  //sunset
  final int? sunset;

  @HiveField(17)
  //time at which data was recorded
  final int? timestamp;

  @HiveField(18)
  //lt
  final double? latitude;

  @HiveField(19)
  //lg
  final double? longitude;

  @HiveField(20)
  //coluds
  final int? cloudiness;

  @HiveField(21)
  //sea level
  final int? seaLevel;

  @HiveField(22)
  //ground level
  final int? grndLevel;

  @HiveField(23)
  // time when api was hit
  final DateTime lastFetched;

  WeatherModel({
    required this.id,
    this.country,
    this.geolocationName,

    this.temperature,
    this.feelsLike,
    this.minTemp,
    this.maxTemp,
    this.condition,
    this.description,
    this.iconCode,
    this.humidity,
    this.windSpeed,
    this.windDeg,
    this.visibility,
    this.pressure,
    this.sunrise,
    this.sunset,
    this.timestamp,
    this.latitude,
    this.longitude,
    this.cloudiness,
    this.seaLevel,
    this.grndLevel,
    required this.lastFetched,
    this.stationName,
  });

  WeatherModel copyWith({
    int? id,
    String? stationName,
    String? geolocationName,
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
    double? windDeg,
    int? visibility,
    int? pressure,
    int? sunrise,
    int? sunset,
    int? timestamp,
    double? latitude,
    double? longitude,
    int? cloudiness,
    int? seaLevel,
    int? grndLevel,
    DateTime? lastFetched,
  }) {
    return WeatherModel(
      id: id ?? this.id,
      stationName: stationName ?? this.stationName,
      country: country ?? this.country,
      geolocationName: geolocationName ?? this.geolocationName,
      temperature: temperature ?? this.temperature,
      feelsLike: feelsLike ?? this.feelsLike,
      minTemp: minTemp ?? this.minTemp,
      maxTemp: maxTemp ?? this.maxTemp,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      windDeg: windDeg ?? this.windDeg,
      visibility: visibility ?? this.visibility,
      pressure: pressure ?? this.pressure,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cloudiness: cloudiness ?? this.cloudiness,
      seaLevel: seaLevel ?? this.seaLevel,
      grndLevel: grndLevel ?? this.grndLevel,
      lastFetched: lastFetched ?? this.lastFetched,
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
      stationName: json['name'],
      geolocationName: null, // Not from API

      temperature: (main['temp'] as num?)?.toDouble(),
      feelsLike: (main['feels_like'] as num?)?.toDouble(),
      minTemp: (main['temp_min'] as num?)?.toDouble(),
      maxTemp: (main['temp_max'] as num?)?.toDouble(),
      condition: weather['main'],
      description: weather['description'],
      iconCode: weather['icon'],
      humidity: main['humidity'],
      windSpeed: (wind['speed'] as num?)?.toDouble(),
      windDeg: (wind['deg'] as num?)?.toDouble(),
      visibility: json['visibility'],
      pressure: main['pressure'],
      sunrise: sys['sunrise'],
      sunset: sys['sunset'],
      timestamp: json['dt'],
      latitude: (coord['lat'] as num?)?.toDouble(),
      longitude: (coord['lon'] as num?)?.toDouble(),
      cloudiness: clouds['all'],
      seaLevel: main['sea_level'],
      grndLevel: main['grnd_level'],
      lastFetched: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': stationName,
      'geolocationName': geolocationName,
      'sys': {'sunrise': sunrise, 'sunset': sunset},
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
      'wind': {'speed': windSpeed, 'deg': windDeg},
      'visibility': visibility,
      'dt': timestamp,
      'coord': {'lat': latitude, 'lon': longitude},
      'clouds': {'all': cloudiness},
      'lastFetched': lastFetched.toIso8601String(),
    };
  }
}
