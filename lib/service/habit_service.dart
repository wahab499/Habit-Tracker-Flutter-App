// services/habit_service.dart
import 'dart:math';
import 'package:habit_chain/model/habit.dart';

class HabitService {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  void addHabit(Habit habit) {
    _habits.add(habit);
  }

  void removeHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
  }

  void updateHabit(Habit updatedHabit) {
    final index = _habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
    }
  }

  void markHabitCompleted(String id) {
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
    }
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
