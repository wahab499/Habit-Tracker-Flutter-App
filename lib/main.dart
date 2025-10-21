import 'package:flutter/material.dart';
import 'package:habit_chain/screens/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Chain',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Homescreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
