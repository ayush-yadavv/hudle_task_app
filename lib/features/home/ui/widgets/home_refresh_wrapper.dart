import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hudle_task_app/features/weather/bloc/weather_bloc.dart';
import 'package:hudle_task_app/utils/constants/app_enums.dart';
import 'package:hudle_task_app/utils/constants/sizes.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeRefreshWrapper extends StatelessWidget {
  final Widget child;

  const HomeRefreshWrapper({super.key, required this.child});

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<WeatherBloc>();
    // Prevent double refresh if already refreshing
    if (bloc.state is! WeatherRefreshing) {
      bloc.add(RefreshWeatherEvent());
      // Wait for refresh to complete by awaiting the first loaded or error state
      await bloc.stream.firstWhere(
        (state) => state is WeatherLoaded || state is WeatherError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch for state changes to update banner status
    return BlocBuilder<WeatherBloc, WeatherState>(
      buildWhen: (previous, current) =>
          current is WeatherLoaded ||
          current is WeatherError ||
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        return CustomRefreshIndicator(
          onRefresh: () => _onRefresh(context),
          trigger: IndicatorTrigger.leadingEdge,
          builder: (context, child, controller) {
            return Column(
              children: [
                // Animated reusable banner logic
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return _buildBanner(context, controller, state);
                  },
                ),
                // The scrollable content
                Expanded(child: child),
              ],
            );
          },
          child: child,
        );
      },
    );
  }

  Widget _buildBanner(
    BuildContext context,
    IndicatorController controller,
    WeatherState state,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const maxHeight = 48.0;
    const iconSize = 20.0;

    // Default Styling
    Color statusColor = isDark
        ? const Color.fromARGB(200, 255, 255, 255)
        : const Color.fromARGB(200, 0, 0, 0);
    String displayMessage = '';
    String currentUiState = 'idle';
    double arrowRotation = 0.0;

    // 1. Determine State from Controller (Pulling/Refreshing)
    if (controller.isDragging) {
      currentUiState = 'pulling';
      arrowRotation = (controller.value.clamp(0.0, 1.0)) * 3.14159;
      displayMessage = controller.value >= 1.0
          ? 'Release to refresh'
          : 'Pull to refresh';
    } else if (controller.isArmed) {
      currentUiState = 'pulling';
      arrowRotation = 3.14159;
      displayMessage = 'Release to refresh';
    } else if (controller.isLoading || controller.isFinalizing) {
      currentUiState = 'refreshing';
      displayMessage = controller.isFinalizing
          ? 'Almost done'
          : 'Updating weather';
    }

    // 2. Override with BLoC State (Success/Error feedback)
    // Only if we are not actively dragging/loading (resilience)
    // or if we strictly want to show result after loading is done
    if (state is WeatherLoaded) {
      if (state.refreshStatus == RefreshStatus.success) {
        currentUiState = 'success';
        statusColor = Colors.green;
        displayMessage = 'Weather updated!';
      } else if (state.refreshStatus == RefreshStatus.error) {
        currentUiState = 'error';
        statusColor = Colors.red;
        displayMessage = 'Update failed';
      }
    }

    // 3. Calculate Layout Values
    final bool isVisible = currentUiState != 'idle';
    final double bannerHeight = isVisible
        ? (controller.isDragging
              ? (controller.value * maxHeight).clamp(0.0, maxHeight)
              : maxHeight)
        : 0.0;

    final double opacity = controller.isDragging
        ? controller.value.clamp(0.3, 1.0)
        : 1.0;

    return AnimatedContainer(
      duration: controller.isDragging
          ? Duration.zero
          : const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      height: bannerHeight,
      child: ClipRect(
        child: OverflowBox(
          maxHeight: maxHeight,
          alignment: Alignment.topCenter,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            opacity: isVisible ? opacity : 0.0,
            child: Container(
              height: maxHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Center(
                child: _BannerContent(
                  uiState: currentUiState,
                  color: statusColor,
                  message: displayMessage,
                  rotation: arrowRotation,
                  iconSize: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerContent extends StatelessWidget {
  const _BannerContent({
    required this.uiState,
    required this.color,
    required this.message,
    required this.rotation,
    required this.iconSize,
  });

  final String uiState;
  final Color color;
  final String message;
  final double rotation;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    switch (uiState) {
      case 'pulling':
        iconWidget = Transform.rotate(
          angle: rotation,
          child: Icon(Iconsax.arrow_down_1_copy, color: color, size: iconSize),
        );
        break;
      case 'refreshing':
        iconWidget = SizedBox(
          width: iconSize,
          height: iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        );
        break;
      case 'success':
        iconWidget = Icon(
          Iconsax.tick_circle_copy,
          color: color,
          size: iconSize,
        );
        break;
      case 'error':
        iconWidget = Icon(Iconsax.warning_2_copy, color: color, size: iconSize);
        break;
      default:
        iconWidget = SizedBox(width: iconSize, height: iconSize);
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Row(
        key: ValueKey('$uiState-$message'),
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: Sizes.spaceBtwItems),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
