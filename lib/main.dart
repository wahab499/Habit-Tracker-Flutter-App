import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_chain/screens/homescreen.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/theme_provider.dart';

void main() {
  // Initialize GetX controllers
  Get.put(ThemeController());
  Get.put(HabitController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() {
      // Access the observable to trigger rebuilds
      final _ = themeController.themeMode;

      return GetMaterialApp(
        title: 'Habit Chain',
        theme: ThemeData(
          //primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.light,
          colorScheme: ColorScheme.light(
            primary: Colors.blue,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black, // Dark text on light background
          ),
        ),
        darkTheme: ThemeData(
          //primarySwatch: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Colors.blue,
            onPrimary: Colors.white,
            surface: Colors.grey[900]!,
            onSurface: Colors.white, // Light text on dark background
          ),
        ),
        themeMode: themeController.themeMode,
        home: const Homescreen(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
