part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

/// Base class for all Action States (One-time events like Navigation, SnackBar, etc.)
abstract class WeatherActionState extends WeatherState {}

// --- UI States (For buildWhen) ---

// --- UI States (For buildWhen) ---

/// Base class for states that should update the Home Screen UI
abstract class HomeWeatherState extends WeatherState {}

final class WeatherInitial extends HomeWeatherState {}

final class WeatherLoading extends HomeWeatherState {}

final class WeatherLoaded extends HomeWeatherState {
  final WeatherModel weather;
  final RefreshStatus refreshStatus;

  WeatherLoaded(this.weather, {this.refreshStatus = RefreshStatus.none});
}

/// Refreshing state - keeps current data visible while showing refresh indicator
final class WeatherRefreshing extends HomeWeatherState {
  final WeatherModel weather;
  WeatherRefreshing(this.weather);
}

final class WeatherError extends HomeWeatherState {
  final String message;
  final String? errorType;
  final WeatherModel? previousWeather;
  WeatherError(this.message, {this.errorType, this.previousWeather});
}

/// State when no location is selected - prompts user to select one
final class NoLocationSelected extends HomeWeatherState {}

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
