import 'package:flutter/material.dart';
import '../models/habit.dart';

class GithubHabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const GithubHabitCard({
    Key? key,
    required this.habit,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompletedToday = habit.isCompletedToday();
    final completionData = habit.getWeeklyCompletionData();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with habit info
              _buildHeader(isCompletedToday),
              const SizedBox(height: 16),

              // GitHub-style contribution graph
              _buildContributionGraph(completionData),
              const SizedBox(height: 12),

              // Stats and footer
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isCompletedToday) {
    return Row(
      children: [
        // Emoji and habit name
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: habit.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            habit.emoji,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (habit.description.isNotEmpty)
                Text(
                  habit.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),

        // Completion indicator
        _buildCompletionIndicator(isCompletedToday),
      ],
    );
  }

  Widget _buildCompletionIndicator(bool isCompleted) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted ? habit.color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? habit.color : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check, size: 18, color: Colors.white)
          : null,
    );
  }

  Widget _buildContributionGraph(Map<DateTime, bool> completionData) {
    final dates = completionData.keys.toList()..sort();
    final weeks = _groupByWeeks(dates);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month labels
        _buildMonthLabels(weeks),
        const SizedBox(height: 8),

        // Contribution grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day labels
            _buildDayLabels(),
            const SizedBox(width: 8),

            // Contribution squares
            Expanded(
              child: _buildContributionGrid(weeks, completionData),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthLabels(List<List<DateTime>> weeks) {
    final monthLabels = <Widget>[];
    String? lastMonth;

    for (int i = 0; i < weeks.length; i++) {
      final week = weeks[i];
      if (week.isNotEmpty) {
        final firstDay = week.first;
        final month = _getMonthAbbreviation(firstDay.month);

        if (month != lastMonth) {
          monthLabels.add(
            SizedBox(
              width: 14, // Same as square size + margin
              child: Text(
                month,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
          lastMonth = month;
        } else {
          monthLabels.add(const SizedBox(width: 14));
        }
      }
    }

    return Row(children: monthLabels);
  }

  Widget _buildDayLabels() {
    const days = ['', 'M', '', 'W', '', 'F', ''];
    return Column(
      children: days.map((day) {
        return Container(
          width: 16,
          height: 14,
          margin: const EdgeInsets.only(bottom: 2),
          child: Text(
            day,
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContributionGrid(
      List<List<DateTime>> weeks, Map<DateTime, bool> completionData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeks.map((week) {
        return Column(
          children: week.map((date) {
            final intensity = habit.getIntensityLevel(date);
            return _buildContributionSquare(intensity, date);
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildContributionSquare(int intensity, DateTime date) {
    Color getSquareColor() {
      switch (intensity) {
        case 1:
          return habit.color.withOpacity(0.3);
        case 2:
          return habit.color.withOpacity(0.5);
        case 3:
          return habit.color.withOpacity(0.7);
        case 4:
          return habit.color;
        default:
          return Colors.grey[100]!;
      }
    }

    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(bottom: 2, right: 2),
      decoration: BoxDecoration(
        color: getSquareColor(),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Tooltip(
        message: _getTooltipText(date, intensity),
        child: const SizedBox.expand(),
      ),
    );
  }

  String _getTooltipText(DateTime date, int intensity) {
    final completed = intensity > 0;
    final dateStr =
        "${_getMonthAbbreviation(date.month)} ${date.day}, ${date.year}";

    if (completed) {
      final level =
          ['', 'Rarely', 'Sometimes', 'Often', 'Very often'][intensity];
      return "$dateStr: Completed ($level)";
    } else {
      return "$dateStr: Not completed";
    }
  }

  Widget _buildFooter() {
    final weeklyCompletions = habit.getWeeklyCompletionCounts();
    final currentWeekCompletions =
        weeklyCompletions.isNotEmpty ? weeklyCompletions.last : 0;
    final averageCompletions = weeklyCompletions.isNotEmpty
        ? (weeklyCompletions.reduce((a, b) => a + b) / weeklyCompletions.length)
            .round()
        : 0;

    return Row(
      children: [
        // Current streak
        _buildFooterItem(
          Icons.local_fire_department,
          '${habit.currentStreak}',
          'day streak',
          Colors.orange,
        ),

        const SizedBox(width: 16),

        // This week
        _buildFooterItem(
          Icons.calendar_today,
          '$currentWeekCompletions/${habit.targetCount}',
          'this week',
          Colors.blue,
        ),

        const Spacer(),

        // Average
        _buildFooterItem(
          Icons.trending_up,
          '$averageCompletions',
          'avg/week',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildFooterItem(
      IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper methods
  List<List<DateTime>> _groupByWeeks(List<DateTime> dates) {
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];

    for (final date in dates) {
      currentWeek.add(date);
      if (currentWeek.length == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }

    if (currentWeek.isNotEmpty) {
      // Fill remaining days with empty dates to maintain grid structure
      while (currentWeek.length < 7) {
        currentWeek.add(DateTime.now()); // Placeholder
      }
      weeks.add(currentWeek);
    }

    return weeks;
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
