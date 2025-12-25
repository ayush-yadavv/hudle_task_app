import 'package:hive/hive.dart';

part 'weather_model.g.dart';

/// Model representing weather data for a specific location.
///
/// This model is used to deserialize data from the OpenWeatherMap API
/// and is stored locally using Hive for caching.
@HiveType(typeId: 0)
class WeatherModel extends HiveObject {
  @HiveField(0)
  /// Unique identifier for the location provided by the API.
  final int id;

  @HiveField(1)
  /// Name of the weather station or city.
  final String? stationName;

  @HiveField(25)
  /// Optional human-readable name of the location resolved via reverse geocoding.
  final String? geolocationName;

  @HiveField(26)
  /// Country code (e.g., "US", "IN").
  final String? country;

  @HiveField(3)
  /// Current temperature, typically in Kelvin (converted by formatters).
  final double? temperature;

  @HiveField(4)
  /// Perceived temperature ("feels like").
  final double? feelsLike;

  @HiveField(5)
  /// Minimum temperature observed in the current period/region.
  final double? minTemp;

  @HiveField(6)
  /// Maximum temperature observed in the current period/region.
  final double? maxTemp;

  @HiveField(7)
  /// Short keyword describing weather (e.g., "Rain", "Clouds").
  final String? condition;

  @HiveField(8)
  /// Detailed description of weather condition.
  final String? description;

  @HiveField(9)
  /// Code used to fetch the weather icon from OpenWeatherMap.
  final String? iconCode;

  @HiveField(10)
  /// Humidity percentage (0-100).
  final int? humidity;

  @HiveField(11)
  /// Wind speed.
  final double? windSpeed;

  @HiveField(12)
  /// Wind direction in degrees.
  final double? windDeg;

  @HiveField(13)
  /// Visibility distance in meters.
  final int? visibility;

  @HiveField(14)
  /// Atmospheric pressure in hPa.
  final int? pressure;

  @HiveField(15)
  /// Sunrise time as a Unix timestamp.
  final int? sunrise;

  @HiveField(16)
  /// Sunset time as a Unix timestamp.
  final int? sunset;

  @HiveField(17)
  /// Time of data calculation as a Unix timestamp.
  final int? timestamp;

  @HiveField(18)
  /// Geographic latitude.
  final double? latitude;

  @HiveField(19)
  /// Geographic longitude.
  final double? longitude;

  @HiveField(20)
  /// Cloudiness percentage (0-100).
  final int? cloudiness;

  @HiveField(21)
  /// Atmospheric pressure at sea level in hPa.
  final int? seaLevel;

  @HiveField(22)
  /// Atmospheric pressure at ground level in hPa.
  final int? grndLevel;

  @HiveField(23)
  /// Local timestamp when this data was fetched from the API.
  /// Used for cache expiration logic.
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

  /// Creates a copy of this [WeatherModel] with updated fields.
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

  /// Factory constructor to create a [WeatherModel] from OpenWeather API JSON response.
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

  /// Converts the [WeatherModel] instance back into a JSON-compatible map.
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
