import 'package:flutter/material.dart';

class ReorderHabits extends StatefulWidget {
  const ReorderHabits({super.key});

  @override
  State<ReorderHabits> createState() => _ReorderHabitsState();
}

class _ReorderHabitsState extends State<ReorderHabits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReOrder Habits'),
      ),
      body: const Center(
        child: Column(
          children: [Text('Long-press and to drag to reorder the habits')],
        ),
      ),
    );
  }
}
