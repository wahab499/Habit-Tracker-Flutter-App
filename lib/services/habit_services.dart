import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitService with ChangeNotifier implements ValueListenable<List<Habit>> {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  @override
  List<Habit> get value => _habits; // Required for ValueListenable

  HabitService() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList('habits') ?? [];
    _habits =
        habitsJson.map((json) => Habit.fromJson(jsonDecode(json))).toList();
    _checkAndResetWeeklyCounts();
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson =
        _habits.map((habit) => jsonEncode(habit.toJson())).toList();
    await prefs.setStringList('habits', habitsJson);
  }

  void _checkAndResetWeeklyCounts() {
    final now = DateTime.now();
    for (var habit in _habits) {
      // Reset weekly counts if it's a new week
      final lastCompletion = habit.completionDates.isNotEmpty
          ? habit.completionDates.last
          : habit.creationDate;

      if (now.difference(lastCompletion).inDays >= 7) {
        habit.currentCount = 0;
      }
    }
  }

  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      await _saveHabits();
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> markHabitCompleted(String habitId,
      {bool completed = true}) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    final today = DateTime.now();

    if (completed && !habit.isCompletedToday()) {
      habit.completionDates.add(today);
      habit.currentCount++;

      // Update streak
      final yesterday = today.subtract(Duration(days: 1));
      final wasCompletedYesterday = habit.completionDates.any((date) =>
          date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day);

      if (wasCompletedYesterday || habit.completionDates.length == 1) {
        habit.currentStreak++;
        if (habit.currentStreak > habit.longestStreak) {
          habit.longestStreak = habit.currentStreak;
        }
      } else {
        habit.currentStreak = 1;
      }
    } else if (!completed) {
      habit.completionDates.removeWhere((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day);
      habit.currentCount = habit.currentCount > 0 ? habit.currentCount - 1 : 0;
    }

    await _saveHabits();
    notifyListeners();
  }

  int getTotalStreak() {
    return _habits.fold(0, (sum, habit) => sum + habit.currentStreak);
  }

  double getOverallSuccessRate() {
    if (_habits.isEmpty) return 0.0;
    final totalRate =
        _habits.fold(0.0, (sum, habit) => sum + habit.successRate);
    return totalRate / _habits.length;
  }
}
