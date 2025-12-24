part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

/// Base class for all Action States (One-time events like Navigation, SnackBar, etc.)
abstract class WeatherActionState extends WeatherState {}

// --- UI States (For buildWhen) ---

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  WeatherLoaded(this.weather);
}

/// Refreshing state - keeps current data visible while showing refresh indicator
final class WeatherRefreshing extends WeatherState {
  final WeatherModel weather;
  WeatherRefreshing(this.weather);
}

final class WeatherError extends WeatherState {
  final String message;
  final String? errorType;
  WeatherError(this.message, {this.errorType});
}

final class LocationSearchLoading extends WeatherState {}

final class LocationSearchLoaded extends WeatherState {
  final List<LocationModel> locations;
  LocationSearchLoaded(this.locations);
}

final class SearchHistoryLoaded extends WeatherState {
  final List<LocationModel> history;
  SearchHistoryLoaded(this.history);
}

// --- Action States (For listenWhen) ---

final class WeatherErrorActionState extends WeatherActionState {
  final String message;
  WeatherErrorActionState(this.message);
}

final class WeatherLoadingActionState extends WeatherActionState {
  final String? message;
  WeatherLoadingActionState({this.message});
}

final class WeatherLoadingCompleteActionState extends WeatherActionState {}

final class LocationSelectedActionState extends WeatherActionState {}
