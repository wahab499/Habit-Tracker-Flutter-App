import 'package:flutter/material.dart';
import 'package:habit_chain/models/habit.dart';

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
    final isCompleted = habit.isCompletedToday();
    final completionData = _getSampleCompletionData(); // For demo purposes

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                habit.color.withOpacity(0.03),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeaderSection(isCompleted),
                const SizedBox(height: 20),

                // GitHub Contribution Graph
                _buildGitHubGraph(completionData),
                const SizedBox(height: 16),

                // Stats Footer
                //_buildStatsFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isCompleted) {
    return Row(
      children: [
        // Emoji with premium design
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                habit.color.withOpacity(0.1),
                habit.color.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: habit.color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            habit.emoji,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(width: 16),

        // Habit Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              if (habit.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    habit.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Completion Indicator
        _buildPremiumCompletionIndicator(isCompleted),
      ],
    );
  }

  Widget _buildPremiumCompletionIndicator(bool isCompleted) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isCompleted ? habit.color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? habit.color : Colors.grey[300]!,
          width: 2,
        ),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                  color: habit.color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: isCompleted
          ? const Icon(Icons.check, size: 18, color: Colors.white)
          : Icon(Icons.circle_outlined, size: 18, color: Colors.grey[400]),
    );
  }

  Widget _buildGitHubGraph(Map<DateTime, int> completionData) {
    final weeks = _groupIntoWeeks(completionData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Labels
        // _buildMonthLabels(weeks),
        const SizedBox(height: 8),

        // Graph Grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Labels
            // _buildDayLabels(),
            const SizedBox(width: 8),

            // Contribution Grid
            Expanded(
              child: _buildContributionGrid(weeks, completionData),
            ),
          ],
        ),

        // Intensity Legend
        //  _buildIntensityLegend(),
      ],
    );
  }

  Widget _buildContributionGrid(
      List<List<DateTime>> weeks, Map<DateTime, int> completionData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: weeks.map((week) {
        return Column(
          children: week.map((date) {
            final intensity = completionData[date] ?? 0;
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
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          if (intensity > 0)
            BoxShadow(
              color: getSquareColor().withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Tooltip(
        message: _getTooltipText(date, intensity),
        preferBelow: false,
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper Methods
  Map<DateTime, int> _getSampleCompletionData() {
    final data = <DateTime, int>{};
    final today = DateTime.now();

    // Generate sample data for last 12 weeks
    for (int i = 0; i < 84; i++) {
      // 12 weeks * 7 days
      final date = today.subtract(Duration(days: 83 - i));
      // Random intensity for demo (in real app, use habit.completionDates)
      final intensity = (i % 7 == 0) ? 0 : (i % 5);
      data[date] = intensity;
    }

    return data;
  }

  List<List<DateTime>> _groupIntoWeeks(Map<DateTime, int> completionData) {
    final dates = completionData.keys.toList()..sort();
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];

    for (final date in dates) {
      currentWeek.add(date);
      if (currentWeek.length == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }

    return weeks;
  }

  String _getTooltipText(DateTime date, int intensity) {
    final completed = intensity > 0;
    final dateStr =
        "${_getMonthAbbreviation(date.month)} ${date.day}, ${date.year}";

    if (completed) {
      final level =
          ['', '1-2 times', '3-4 times', '5-6 times', 'Daily'][intensity];
      return "$dateStr: $level";
    } else {
      return "$dateStr: No activity";
    }
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
