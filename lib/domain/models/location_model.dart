import 'package:hive/hive.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';

part 'location_model.g.dart';

@HiveType(typeId: 1)
class LocationModel extends HiveObject {
  @HiveField(0)
  //name of location
  final String? name;

  @HiveField(1)
  //country of location
  final String? country;

  @HiveField(2)
  //state of location
  final String? state;

  @HiveField(3)
  //latitude of location
  final double lat;

  @HiveField(4)
  //longitude of location
  final double lon;

  @HiveField(5)
  //last fetched time of geo-location
  final DateTime? lastFetched;

  @HiveField(6)
  //weather of location
  final WeatherModel? weather;

  @HiveField(7)
  //id of location
  final String id;

  LocationModel({
    this.name,
    this.country,
    this.state,
    required this.lat,
    required this.lon,
    this.lastFetched,
    this.weather,
    required this.id,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    final lat = (json['lat'] as num?)?.toDouble() ?? 0.0;
    final lon = (json['lon'] as num?)?.toDouble() ?? 0.0;

    return LocationModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      lat: lat,
      lon: lon,
      lastFetched: json['lastFetched'] != null
          ? DateTime.tryParse(json['lastFetched'].toString())
          : null,
      weather: json['weather'] != null
          ? WeatherModel.fromJson(json['weather'])
          : null,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'state': state,
      'lat': lat,
      'lon': lon,
      'lastFetched': lastFetched?.toIso8601String(),
      'weather': weather?.toJson(),
      'id': id,
    };
  }

  LocationModel copyWith({
    String? id,
    String? name,
    String? country,
    String? state,
    double? lat,
    double? lon,
    DateTime? lastFetched,
    WeatherModel? weather,
  }) {
    return LocationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      lastFetched: lastFetched ?? this.lastFetched,
      weather: weather ?? this.weather,
    );
  }

  /// Returns a formatted display name combining available location parts
  String get displayName {
    final parts = <String>[];

    if (name != null && name!.isNotEmpty) {
      parts.add(name!);
    }

    if (state != null && state!.isNotEmpty) {
      parts.add(state!);
    }

    if (country != null && country!.isNotEmpty) {
      parts.add(country!);
    }

    if (parts.isEmpty) {
      return 'Unknown Location';
    }

    return parts.join(', ');
  }

  /// Equality check to help with duplicate prevention in history
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          lat == other.lat &&
          lon == other.lon;

  @override
  int get hashCode => name.hashCode ^ lat.hashCode ^ lon.hashCode;
}
