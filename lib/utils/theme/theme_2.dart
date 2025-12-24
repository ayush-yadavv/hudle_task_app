// import 'package:flex_color_scheme/flex_color_scheme.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// /// The [AppTheme] defines light and dark themes for the app.
// ///
// /// Theme setup for FlexColorScheme package v8.
// /// Use same major flex_color_scheme package version. If you use a
// /// lower minor version, some properties may not be supported.
// /// In that case, remove them after copying this theme to your
// /// app or upgrade the package to version 8.3.1.
// ///
// /// Use it in a [MaterialApp] like this:
// ///
// /// MaterialApp(
// ///   theme: AppTheme.light,
// ///   darkTheme: AppTheme.dark,
// /// );
// abstract final class AppTheme {
//   // The FlexColorScheme defined light mode ThemeData.
//   static ThemeData lightTheme = FlexThemeData.light(
//     // Using FlexColorScheme built-in FlexScheme enum based colors
//     scheme: FlexScheme.shadRose,
//     // Input color modifiers.
//     useMaterial3ErrorColors: true,
//     fontFamily: 'Poppins',

//     // Surface color adjustments.
//     surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
//     blendLevel: 2,
//     // Convenience direct styling properties.
//     transparentStatusBar: false,
//     tooltipsMatchBackground: true,

//     // Component theme configurations for light mode.
//     subThemesData: const FlexSubThemesData(
//       interactionEffects: true,
//       tintedDisabledControls: true,
//       blendOnLevel: 10,
//       useMaterial3Typography: true,
//       useM2StyleDividerInM3: true,
//       adaptiveRadius: FlexAdaptive.all(),
//       outlinedButtonOutlineSchemeColor: SchemeColor.primary,
//       outlinedButtonPressedBorderWidth: 2.0,
//       toggleButtonsBorderSchemeColor: SchemeColor.primary,
//       segmentedButtonSchemeColor: SchemeColor.primary,
//       segmentedButtonBorderSchemeColor: SchemeColor.primary,
//       unselectedToggleIsColored: true,
//       sliderValueTinted: true,
//       inputDecoratorSchemeColor: SchemeColor.primary,
//       inputDecoratorBackgroundAlpha: 21,
//       inputDecoratorBorderType: FlexInputBorderType.outline,
//       inputDecoratorRadius: 12.0,
//       inputDecoratorUnfocusedBorderIsColored: true,
//       inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
//       fabUseShape: true,
//       fabAlwaysCircular: true,
//       chipBlendColors: true,
//       popupMenuRadius: 6.0,
//       popupMenuElevation: 4.0,
//       popupMenuOpacity: 0.50,
//       alignedDropdown: true,
//       useInputDecoratorThemeInDialogs: true,
//       appBarCenterTitle: false,
//       tabBarDividerColor: Color(0x00000000),
//       drawerIndicatorSchemeColor: SchemeColor.primary,
//       bottomNavigationBarShowSelectedLabels: false,
//       bottomNavigationBarShowUnselectedLabels: false,
//       menuRadius: 6.0,
//       menuElevation: 8.0,
//       menuBarRadius: 0.0,
//       menuBarElevation: 1.0,
//       menuBarShadowColor: Color(0x00000000),
//       navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
//       navigationBarMutedUnselectedLabel: true,
//       navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
//       navigationBarMutedUnselectedIcon: true,
//       navigationBarIndicatorSchemeColor: SchemeColor.primary,
//       navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//       navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
//       navigationRailMutedUnselectedLabel: true,
//       navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
//       navigationRailMutedUnselectedIcon: true,
//       navigationRailUseIndicator: true,
//       navigationRailIndicatorSchemeColor: SchemeColor.primary,
//       navigationRailIndicatorOpacity: 0.50,
//       navigationRailLabelType: NavigationRailLabelType.all,
//     ),
//     // Direct ThemeData properties.
//     visualDensity: FlexColorScheme.comfortablePlatformDensity,
//     cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
//   );

//   // The FlexColorScheme defined dark mode ThemeData.
//   static ThemeData darkTheme = FlexThemeData.dark(
//     fontFamily: 'Poppins',
//     // Playground built-in light mode scheme is used and converted to
//     // a dark theme using defaultError and toDark() methods.
//     colors: FlexColor.schemes[FlexScheme.shadRose]!.light.defaultError.toDark(
//       10,
//       false,
//     ),
//     // Input color modifiers.
//     useMaterial3ErrorColors: true,
//     // Surface color adjustments.
//     surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
//     blendLevel: 8,
//     // Convenience direct styling properties.
//     transparentStatusBar: false,
//     tooltipsMatchBackground: true,
//     // Component theme configurations for dark mode.
//     subThemesData: const FlexSubThemesData(
//       interactionEffects: true,
//       tintedDisabledControls: true,
//       blendOnLevel: 2,
//       blendOnColors: true,
//       useMaterial3Typography: true,
//       useM2StyleDividerInM3: true,
//       adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
//       adaptiveRadius: FlexAdaptive.all(),
//       outlinedButtonOutlineSchemeColor: SchemeColor.primary,
//       outlinedButtonPressedBorderWidth: 2.0,
//       toggleButtonsBorderSchemeColor: SchemeColor.primary,
//       segmentedButtonSchemeColor: SchemeColor.primary,
//       segmentedButtonBorderSchemeColor: SchemeColor.primary,
//       unselectedToggleIsColored: true,
//       sliderValueTinted: true,
//       inputDecoratorSchemeColor: SchemeColor.primary,
//       inputDecoratorBackgroundAlpha: 30,
//       inputDecoratorBorderType: FlexInputBorderType.outline,
//       inputDecoratorRadius: 12.0,
//       inputDecoratorUnfocusedBorderIsColored: true,
//       fabUseShape: true,
//       fabAlwaysCircular: true,
//       chipBlendColors: true,
//       popupMenuRadius: 6.0,
//       popupMenuElevation: 4.0,
//       popupMenuOpacity: 0.50,
//       alignedDropdown: true,
//       useInputDecoratorThemeInDialogs: true,
//       appBarBackgroundSchemeColor: SchemeColor.black,
//       appBarCenterTitle: false,
//       tabBarDividerColor: Color(0x00000000),
//       drawerIndicatorSchemeColor: SchemeColor.primary,
//       bottomNavigationBarShowSelectedLabels: false,
//       bottomNavigationBarShowUnselectedLabels: false,
//       menuRadius: 6.0,
//       menuElevation: 8.0,
//       menuBarRadius: 0.0,
//       menuBarElevation: 1.0,
//       menuBarShadowColor: Color(0x00000000),
//       navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
//       navigationBarMutedUnselectedLabel: true,
//       navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
//       navigationBarMutedUnselectedIcon: true,
//       navigationBarIndicatorSchemeColor: SchemeColor.primary,
//       navigationBarLabelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//       navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
//       navigationRailMutedUnselectedLabel: true,
//       navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
//       navigationRailMutedUnselectedIcon: true,
//       navigationRailUseIndicator: true,
//       navigationRailIndicatorSchemeColor: SchemeColor.primary,
//       navigationRailIndicatorOpacity: 0.50,
//       navigationRailLabelType: NavigationRailLabelType.all,
//     ),
//     // Direct ThemeData properties.
//     visualDensity: FlexColorScheme.comfortablePlatformDensity,
//     cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
//   );
// }
