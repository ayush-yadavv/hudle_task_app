import 'package:hive/hive.dart';

part 'location_model.g.dart';

@HiveType(typeId: 1)
class LocationModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String country;
  @HiveField(2)
  final String state;
  @HiveField(3)
  final double lat;
  @HiveField(4)
  final double lon;
  @HiveField(5)
  final DateTime? lastFetched;

  LocationModel({
    required this.name,
    required this.country,
    required this.state,
    required this.lat,
    required this.lon,
    this.lastFetched,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      lastFetched: json['lastFetched'] != null
          ? DateTime.tryParse(json['lastFetched'].toString())
          : null,
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
    };
  }

  String get displayName {
    if (state.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
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
