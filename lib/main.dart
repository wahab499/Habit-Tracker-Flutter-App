import 'package:flutter/material.dart';
import 'package:habit_chain/services/habit_services.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final HabitService habitService = HabitService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Chain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomeScreen(habitService: habitService),
      debugShowCheckedModeBanner: false,
    );
  }
}
