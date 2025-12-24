import 'package:flutter/material.dart';

class AppBottomSheetTheme {
  AppBottomSheetTheme._();

  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    clipBehavior: Clip.antiAlias,
    dragHandleColor: Colors.black54,
    backgroundColor: Color(0xFF212121),
    modalBackgroundColor: const Color.fromARGB(22, 35, 35, 35),
    modalBarrierColor: Colors.transparent,

    // constraints: const BoxConstraints(minHeight: 200),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
  );

  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    clipBehavior: Clip.antiAlias,

    dragHandleColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    showDragHandle: true,
    backgroundColor: Color(0xFF212121),
    modalBackgroundColor: const Color.fromARGB(22, 35, 35, 35),
    modalBarrierColor: Colors.transparent,
    // constraints: const BoxConstraints(minHeight: double.infinity),
  );
}
