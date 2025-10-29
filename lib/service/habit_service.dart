// services/habit_service.dart
import 'dart:convert';
import 'dart:math';
import 'package:habit_chain/model/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitService {
  List<Habit> _habits = [];
  static const String _habitsKey = 'habits';

  List<Habit> get habits => _habits;

  // Load habits from local storage
  Future<void> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList(_habitsKey) ?? [];

    _habits =
        habitsJson.map((json) => Habit.fromJson(jsonDecode(json))).toList();
  }

  // Save habits to local storage
  Future<void> saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson =
        _habits.map((habit) => jsonEncode(habit.toJson())).toList();

    await prefs.setStringList(_habitsKey, habitsJson);
  }

  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await saveHabits();
  }

  Future<void> removeHabit(String id) async {
    _habits.removeWhere((habit) => habit.id == id);
    await saveHabits();
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final index = _habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      await saveHabits();
    }
  }

  Future<void> markHabitCompleted(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final today = DateTime.now();

    // Check if already completed today
    if (!habit.isCompletedToday()) {
      habit.completionDates.add(today);
      habit.currentCount++;

      // Update streak logic
      final yesterday = today.subtract(Duration(days: 1));
      final wasCompletedYesterday = habit.completionDates.any((date) =>
          date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day);

      if (wasCompletedYesterday) {
        habit.currentStreak++;
      } else {
        habit.currentStreak = 1;
      }

      habit.longestStreak = max(habit.longestStreak, habit.currentStreak);

      await saveHabits();
    }
  }

  Future<void> markHabitUncompleted(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);
    final today = DateTime.now();

    // Remove today's completion if it exists
    habit.completionDates.removeWhere((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);

    if (habit.currentCount > 0) {
      habit.currentCount--;
    }

    await saveHabits();
  }

  void resetWeeklyCounts() {
    for (var habit in _habits) {
      habit.currentCount = 0;
    }
  }

  double getWeeklyProgress(Habit habit) {
    return habit.currentCount / habit.targetCount;
  }
}
