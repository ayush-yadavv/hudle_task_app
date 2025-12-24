part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

/// Event to load initial weather - loads from persistence or uses default city
final class LoadInitialWeatherEvent extends WeatherEvent {}

/// Event to fetch weather by station/city name
final class FetchWeatherByCityEvent extends WeatherEvent {
  final String stationName;

  FetchWeatherByCityEvent(this.stationName);
}

/// Event to fetch weather by coordinates
final class FetchWeatherByCoordinatesEvent extends WeatherEvent {
  final double latitude;
  final double longitude;
  final LocationModel? location;

  FetchWeatherByCoordinatesEvent({
    required this.latitude,
    required this.longitude,
    this.location,
  });
}

/// Event to refresh current weather data
final class RefreshWeatherEvent extends WeatherEvent {
  RefreshWeatherEvent();
}

/// Event to search for locations
final class SearchLocationsEvent extends WeatherEvent {
  final String query;

  SearchLocationsEvent(this.query);
}

/// Event to load search history
final class LoadSearchHistoryEvent extends WeatherEvent {}

/// Event to remove a location from search history
final class RemoveFromHistoryEvent extends WeatherEvent {
  final LocationModel location;
  RemoveFromHistoryEvent(this.location);
}
