import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/coman/widgets/custom_sliver_app_bar.dart';
import 'package:hudle_task_app/coman/widgets/search_container.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/features/weather/ui/delegates/location_search_delegate.dart';
import 'package:hudle_task_app/features/weather/ui/helpers/weather_failure_mapper.dart';
import 'package:hudle_task_app/features/weather/ui/widgets/location_list.dart';
import 'package:hudle_task_app/utils/loaders/loaders.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh history whenever the screen is opened
    context.read<WeatherBloc>().add(LoadSearchHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const ASliverAppBar(title: 'Search Location', implyLeading: true),
            SliverToBoxAdapter(
              child: SearchContainer(
                text: 'Search Location',
                onTap: () =>
                    context.read<WeatherBloc>().add(OpenSearchDelegateEvent()),
              ),
            ),
          ],
          body: BlocConsumer<WeatherBloc, WeatherState>(
            buildWhen: (previous, current) => current is SearchHistoryLoaded,
            listenWhen: (previous, current) => current is WeatherActionState,
            listener: (context, state) {
              if (state is WeatherErrorActionState) {
                SLoader.errorSnackBar(
                  context,
                  message: state.failure.getUserMessage(context),
                );
              } else if (state is OpenSearchDelegateActionState) {
                showSearch(
                  context: context,
                  delegate: LocationSearchDelegate(
                    weatherBloc: context.read<WeatherBloc>(),
                  ),
                );
              } else if (state is LocationSelectedActionState) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              if (state is SearchHistoryLoaded) {
                return LocationList(
                  locations: state.history,
                  onLocationSelected: (location) {
                    context.read<WeatherBloc>().add(
                      FetchWeatherByCoordinatesEvent(
                        latitude: location.lat,
                        longitude: location.lon,
                        location: location,
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
