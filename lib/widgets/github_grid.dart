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
      // Calculate the current week number
      final currentWeek = _getCurrentWeekNumber();
      final weekWidth = 12.0 + widget.columnSpacing; // 12px box + spacing
      final targetOffset = currentWeek * weekWidth;

      // Scroll to show the current week as the rightmost visible column
      // Leave some space for the current week to be fully visible
      final screenWidth = MediaQuery.of(context).size.width;
      final targetScroll = (targetOffset - screenWidth + 200)
          .clamp(0.0, _scrollController.position.maxScrollExtent);

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  int _getCurrentWeekNumber() {
    // Get the week number of the current date
    final startOfYear = DateTime(_today.year, 1, 1);
    final daysSinceStart = _today.difference(startOfYear).inDays;
    return (daysSinceStart / 7).floor();
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

    // Generate weeks until we cover the entire year
    while (currentDate.year <= _today.year) {
      weeks.add(_buildWeek(currentDate));
      currentDate = currentDate.add(Duration(days: 7));

      // Stop if we've gone past the current year
      if (currentDate.year > _today.year) break;
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

          return Padding(
            padding: EdgeInsets.only(bottom: widget.rowSpacing),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getDayColor(isCompleted, isToday),
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: _getBorderColor(isCompleted, isToday),
                  width: isToday ? 2 : 1,
                ),
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

  Color _getDayColor(bool isCompleted, bool isToday) {
    if (isCompleted) {
      return widget.habitColor ?? Colors.green;
    } else if (isToday) {
      return (widget.habitColor ?? Colors.green).withOpacity(0.3);
    } else {
      return Colors.transparent;
    }
  }

  Color _getBorderColor(bool isCompleted, bool isToday) {
    if (isToday) {
      return widget.habitColor ?? Colors.green;
    } else if (isCompleted) {
      return widget.habitColor ?? Colors.green;
    } else {
      return Colors.grey[300]!;
    }
  }
}
