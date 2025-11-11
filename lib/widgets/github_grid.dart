import 'package:flutter/material.dart';

/// GitHub-style contribution grid showing a full year of weeks
/// - [completionDates]: List of dates when the habit was completed
/// - [habitColor]: Color to use for completed days
class ContributionGrid extends StatefulWidget {
  final List<DateTime> completionDates;
  final Color? habitColor;
  final double columnSpacing;
  final double rowSpacing;

  const ContributionGrid({
    Key? key,
    required this.completionDates,
    this.habitColor,
    this.columnSpacing = 6.0,
    this.rowSpacing = 6.0,
  }) : super(key: key);

  @override
  State<ContributionGrid> createState() => _ContributionGridState();
}

class _ContributionGridState extends State<ContributionGrid> {
  late DateTime _startOfYear;
  late DateTime _today;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _startOfYear = DateTime(_today.year, 1, 1);
    _scrollController = ScrollController();

    // Auto-scroll to current week after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentWeek();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentWeek() {
    if (_scrollController.hasClients) {
      // Scroll to the very end to show current week as the last column
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildWeeks(),
      ),
    );
  }

  List<Widget> _buildWeeks() {
    List<Widget> weeks = [];

    // Get the first Monday of the year or start from Jan 1st
    DateTime currentDate = _startOfYear;
    int dayOfWeek = currentDate.weekday;
    if (dayOfWeek != 1) {
      // If not Monday, go back to previous Monday
      currentDate = currentDate.subtract(Duration(days: dayOfWeek - 1));
    }

    // Generate weeks until we cover the entire year plus current week
    DateTime lastDate =
        _today.add(Duration(days: 7 - _today.weekday)); // End of current week
    while (currentDate.isBefore(lastDate) ||
        currentDate.isAtSameMomentAs(lastDate)) {
      weeks.add(_buildWeek(currentDate));
      currentDate = currentDate.add(Duration(days: 7));
    }

    return weeks;
  }

  Widget _buildWeek(DateTime weekStart) {
    return Padding(
      padding: EdgeInsets.only(right: widget.columnSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(7, (dayIndex) {
          final dayDate = weekStart.add(Duration(days: dayIndex));
          final isCompleted = _isDateCompleted(dayDate);
          final isToday = _isToday(dayDate);
          final isFutureDate = dayDate.isAfter(_today);

          return Padding(
            padding: EdgeInsets.only(bottom: widget.rowSpacing),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getDayColor(isCompleted, isToday, isFutureDate),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  bool _isDateCompleted(DateTime date) {
    return widget.completionDates.any((completionDate) =>
        completionDate.year == date.year &&
        completionDate.month == date.month &&
        completionDate.day == date.day);
  }

  bool _isToday(DateTime date) {
    return date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;
  }

  Color _getDayColor(bool isCompleted, bool isToday, bool isFutureDate) {
    final Color baseColor = widget.habitColor ?? Colors.green;

    if (isFutureDate) {
      return baseColor.withValues(alpha: 0.1); // Very light for future dates
    } else if (isCompleted) {
      return baseColor; // Full color for completed days
    } else if (isToday) {
      return baseColor.withValues(alpha: 0.6); // Medium opacity for today
    } else {
      return baseColor.withValues(
          alpha: 0.15); // Light color for all other boxes
    }
  }

  // This method is no longer used since we removed borders, but keeping it in case you need it elsewhere
  Color _getBorderColor(bool isCompleted, bool isToday, bool isFutureDate) {
    if (isFutureDate) {
      return Colors.grey[200]!; // Lighter border for future dates
    } else if (isToday) {
      return widget.habitColor ?? Colors.green;
    } else if (isCompleted) {
      return widget.habitColor ?? Colors.green;
    } else {
      return Colors.grey[300]!;
    }
  }
}
