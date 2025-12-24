import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hudle_task_app/domain/models/settings_model.dart';
import 'package:hudle_task_app/domain/models/weather_model.dart';
import 'package:hudle_task_app/features/home/ui/widgets/home_app_bar.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_bloc.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_event.dart';
import 'package:hudle_task_app/features/settings/bloc/settings_state.dart';
import 'package:hudle_task_app/features/settings/ui/settings_screen.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/search_location_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

class MockSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;
  late MockSettingsBloc mockSettingsBloc;

  setUpAll(() {
    registerFallbackValue(LoadInitialWeatherEvent());
  });

  final tSettings = SettingsModel();
  final tSettingsState = SettingsState(settings: tSettings);

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
    mockSettingsBloc = MockSettingsBloc();

    when(() => mockSettingsBloc.state).thenReturn(tSettingsState);
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherBloc>.value(value: mockWeatherBloc),
        BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
      ],
      child: MaterialApp(home: const Scaffold(appBar: HomeAppBar())),
    );
  }

  final tWeather = WeatherModel(
    id: 1,
    stationName: 'London',
    temperature: 20.0,
    description: 'Sunny',
    iconCode: '01d',
    humidity: 50,
    windSpeed: 5.0,
    latitude: 51.5074,
    longitude: -0.1278,
    timestamp: 1600000000,
    feelsLike: 18.0,
    pressure: 1012,
    minTemp: 15.0,
    maxTemp: 22.0,
    lastFetched: DateTime.now(),
  );

  group('HomeAppBar', () {
    testWidgets('displays "Select Location" when no location is selected', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(NoLocationSelected());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Select Location'), findsOneWidget);
      expect(find.text('Tap to search'), findsOneWidget);
    });

    testWidgets('displays "Select Location" in WeatherInitial state', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(WeatherInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Select Location'), findsOneWidget);
    });

    testWidgets('displays city name and "Loading..." in WeatherLoading state', (
      tester,
    ) async {
      when(
        () => mockWeatherBloc.state,
      ).thenReturn(WeatherLoading(cityName: 'Paris'));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('displays city name and subtitle when weather is loaded', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoaded(tWeather));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('London'), findsOneWidget);
      expect(find.textContaining('Last Updated'), findsOneWidget);
    });

    testWidgets('displays city name and subtitle in WeatherRefreshing state', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(WeatherRefreshing(tWeather));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('London'), findsOneWidget);
      expect(find.textContaining('Last Updated'), findsOneWidget);
    });

    testWidgets(
      'displays city name and subtitle in WeatherError state with previous weather',
      (tester) async {
        when(
          () => mockWeatherBloc.state,
        ).thenReturn(WeatherError('Network Error', previousWeather: tWeather));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('London'), findsOneWidget);
        expect(find.textContaining('Last Updated'), findsOneWidget);
      },
    );

    testWidgets(
      'displays "Select Location" in WeatherError state without previous weather',
      (tester) async {
        when(
          () => mockWeatherBloc.state,
        ).thenReturn(WeatherError('Fatal Error'));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.text('Select Location'), findsOneWidget);
      },
    );

    testWidgets('displays geolocation name if different from station name', (
      tester,
    ) async {
      final weatherWithGeo = tWeather.copyWith(geolocationName: 'My Home');
      when(
        () => mockWeatherBloc.state,
      ).thenReturn(WeatherLoaded(weatherWithGeo));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('My Home (London)'), findsOneWidget);
    });

    testWidgets('triggers RefreshWeatherEvent on title double tap', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoaded(tWeather));

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('London'));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('London'));
      await tester.pumpAndSettle();

      verify(
        () => mockWeatherBloc.add(any(that: isA<RefreshWeatherEvent>())),
      ).called(1);
    });

    testWidgets('navigates to SearchLocationScreen on title tap', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoaded(tWeather));

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('London'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SearchLocationScreen), findsOneWidget);
    });

    testWidgets('navigates to SearchLocationScreen on menu button tap', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(NoLocationSelected());

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Iconsax.menu_1_copy));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SearchLocationScreen), findsOneWidget);
    });

    testWidgets('navigates to SettingsScreen on settings button tap', (
      tester,
    ) async {
      when(() => mockWeatherBloc.state).thenReturn(NoLocationSelected());

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byIcon(Iconsax.setting_2_copy));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
