import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:habit_chain/model/habit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitController extends GetxController {
  final RxList<Habit> _habits = <Habit>[].obs;
  final RxBool _isLoading = true.obs;
  static const String _habitsKey = 'habits';

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadHabits();
  }

  // Load habits from local storage
  Future<void> loadHabits() async {
    _isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final habitsJson = prefs.getStringList(_habitsKey) ?? [];

      _habits.value =
          habitsJson.map((json) => Habit.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      // Handle error
      _habits.value = [];
    } finally {
      _isLoading.value = false;
    }
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

  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await saveHabits();
    }
  }

  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    await saveHabits();
  }

  Future<void> markHabitCompleted(String id) async {
    final habitIndex = _habits.indexWhere((h) => h.id == id);
    if (habitIndex == -1) return;
    
    final habit = _habits[habitIndex];
    final today = DateTime.now();

    // Check if already completed today
    if (!habit.isCompletedToday()) {
      final updatedHabit = Habit(
        id: habit.id,
        name: habit.name,
        description: habit.description,
        targetCount: habit.targetCount,
        currentCount: habit.currentCount + 1,
        currentStreak: habit.currentStreak,
        longestStreak: habit.longestStreak,
        creationDate: habit.creationDate,
        completionDates: List<DateTime>.from(habit.completionDates)..add(today),
        color: habit.color,
        emoji: habit.emoji,
        isGoodHabit: habit.isGoodHabit,
      );

      // Update streak logic
      final yesterday = today.subtract(const Duration(days: 1));
      final wasCompletedYesterday = updatedHabit.completionDates.any((date) =>
          date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day);

      if (wasCompletedYesterday) {
        updatedHabit.currentStreak++;
      } else {
        updatedHabit.currentStreak = 1;
      }

      updatedHabit.longestStreak = max(updatedHabit.longestStreak, updatedHabit.currentStreak);

      _habits[habitIndex] = updatedHabit;
      await saveHabits();
    }
  }

  Future<void> markHabitUncompleted(String id) async {
    final habitIndex = _habits.indexWhere((h) => h.id == id);
    if (habitIndex == -1) return;
    
    final habit = _habits[habitIndex];
    final today = DateTime.now();

    // Remove today's completion if it exists
    final updatedCompletionDates = List<DateTime>.from(habit.completionDates);
    updatedCompletionDates.removeWhere((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);

    final updatedHabit = Habit(
      id: habit.id,
      name: habit.name,
      description: habit.description,
      targetCount: habit.targetCount,
      currentCount: habit.currentCount > 0 ? habit.currentCount - 1 : 0,
      currentStreak: habit.currentStreak,
      longestStreak: habit.longestStreak,
      creationDate: habit.creationDate,
      completionDates: updatedCompletionDates,
      color: habit.color,
      emoji: habit.emoji,
      isGoodHabit: habit.isGoodHabit,
    );

    _habits[habitIndex] = updatedHabit;
    await saveHabits();
  }

  void resetWeeklyCounts() {
    for (int i = 0; i < _habits.length; i++) {
      final habit = _habits[i];
      final updatedHabit = Habit(
        id: habit.id,
        name: habit.name,
        description: habit.description,
        targetCount: habit.targetCount,
        currentCount: 0,
        currentStreak: habit.currentStreak,
        longestStreak: habit.longestStreak,
        creationDate: habit.creationDate,
        completionDates: habit.completionDates,
        color: habit.color,
        emoji: habit.emoji,
        isGoodHabit: habit.isGoodHabit,
      );
      _habits[i] = updatedHabit;
    }
  }

  double getWeeklyProgress(Habit habit) {
    return habit.currentCount / habit.targetCount;
  }
}
