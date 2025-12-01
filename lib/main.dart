import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_chain/screens/homescreen.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/settings/general.dart';
import 'package:habit_chain/theme_provider.dart';

// ADD THIS
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

void main() {
  // Initialize GetX controllers
  Get.put(ThemeController());
  Get.put(HabitController());
  Get.put(SettingsController());

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Disable on release build
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      final _ = themeController.themeMode;

      return GetMaterialApp(
        title: 'Habit Chain',
        builder: DevicePreview.appBuilder, // ADD THIS

        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light(
            primary: Color(0xff4CAF50),
            onPrimary: Colors.white,
            surface: Color(0xffF5F7FA),
            onSurface: Colors.black,
          ),
        ),

        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
            onPrimary: Colors.white,
            surface: Color(0xFF1A1A1A),
          ),
        ),

        themeMode: themeController.themeMode,
        home: const Homescreen(),
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context), // ADD THIS
      );
    });
  }
}
