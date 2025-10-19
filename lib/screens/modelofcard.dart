// Add these methods to your existing Habit class in models/habit.dart

class Habit {
  get completionDates => null;

  // ... your existing properties ...

  // Get completion data for the last 52 weeks (like GitHub)
  Map<DateTime, bool> getWeeklyCompletionData() {
    final Map<DateTime, bool> completionMap = {};
    final today = DateTime.now();

    // Start from 51 weeks ago (GitHub shows 52 weeks)
    final startDate = today.subtract(const Duration(days: 51 * 7));

    // Create a map of all dates in the range
    DateTime currentDate = startDate;
    while (currentDate.isBefore(today) || currentDate.isAtSameMomentAs(today)) {
      completionMap[currentDate] = false;
      currentDate = currentDate.add(const Duration(days: 1));
    }

    // Mark completed dates
    for (final completionDate in completionDates) {
      final normalizedDate = DateTime(
          completionDate.year, completionDate.month, completionDate.day);
      if (completionMap.containsKey(normalizedDate)) {
        completionMap[normalizedDate] = true;
      }
    }

    return completionMap;
  }

  // Get completion count for each week
  List<int> getWeeklyCompletionCounts() {
    final completionData = getWeeklyCompletionData();
    final weeks = <int>[];
    var currentWeekCompletions = 0;
    var dayInWeek = 0;

    final dates = completionData.keys.toList()..sort();

    for (final date in dates) {
      if (completionData[date]!) {
        currentWeekCompletions++;
      }

      dayInWeek++;
      if (dayInWeek == 7) {
        weeks.add(currentWeekCompletions);
        currentWeekCompletions = 0;
        dayInWeek = 0;
      }
    }

    // Add the last week if incomplete
    if (dayInWeek > 0) {
      weeks.add(currentWeekCompletions);
    }

    return weeks;
  }

  // Get the intensity level for a day (0-4 like GitHub)
  int getIntensityLevel(DateTime date) {
    final completed = completionDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);

    if (!completed) return 0;

    // Calculate intensity based on how consistent the habit is
    final weeklyCompletions = getWeeklyCompletionCounts();
    final averageCompletions = weeklyCompletions.isNotEmpty
        ? weeklyCompletions.reduce((a, b) => a + b) / weeklyCompletions.length
        : 0;

    if (averageCompletions >= 6) return 4; // Very consistent
    if (averageCompletions >= 4) return 3; // Consistent
    if (averageCompletions >= 2) return 2; // Somewhat consistent
    return 1; // Rare
  }
}
