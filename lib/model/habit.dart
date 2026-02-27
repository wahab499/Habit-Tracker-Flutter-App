import 'dart:ui';

class Habit {
  String id;
  String name;
  String description;
  int targetCount; // Times per week
  int currentCount; // Completed this week
  int currentStreak;
  int longestStreak;
  DateTime creationDate;
  List<DateTime> completionDates;
  Color color;
  String emoji;
  bool isGoodHabit;
  bool isArchived;
  bool isPinned;

  Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.targetCount,
    this.currentCount = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.creationDate,
    this.completionDates = const [],
    required this.color,
    required this.emoji,
    this.isGoodHabit = true,
    this.isArchived = false,
    this.isPinned = false,
  });

  double get weeklyProgress {
    return currentCount / targetCount;
  }

  double get successRate {
    if (completionDates.isEmpty) return 0.0;
    final daysSinceCreation = DateTime.now().difference(creationDate).inDays;
    return completionDates.length /
        daysSinceCreation.clamp(1, double.maxFinite);
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    return completionDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  bool isCompletedYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return completionDates.any((date) =>
        date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'creationDate': creationDate.toIso8601String(),
      'completionDates':
          completionDates.map((d) => d.toIso8601String()).toList(),
      'color': color.value,
      'emoji': emoji,
      'isGoodHabit': isGoodHabit,
      'isArchived': isArchived,
      'isPinned': isPinned,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      targetCount: json['targetCount'],
      currentCount: json['currentCount'],
      currentStreak: json['currentStreak'],
      longestStreak: json['longestStreak'],
      creationDate: DateTime.parse(json['creationDate']),
      completionDates: (json['completionDates'] as List)
          .map((d) => DateTime.parse(d))
          .toList(),
      color: Color(json['color']),
      emoji: json['emoji'],
      isGoodHabit: json['isGoodHabit'],
      isArchived: json['isArchived'] ?? false,
      isPinned: json['isPinned'] ?? false,
    );
  }

  getWeeklyCompletionCounts() {}

  getIntensityLevel(DateTime date) {}

  getWeeklyCompletionData() {}
}
