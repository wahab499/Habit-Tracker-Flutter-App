import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_chain/settings/general.dart';

class ContributionGrid extends StatefulWidget {
  final List<DateTime> completionDates;
  final Color? habitColor;
  final double columnSpacing;
  final double rowSpacing;

  const ContributionGrid({
    Key? key,
    required this.completionDates,
    this.habitColor,
    this.columnSpacing = 5.0,
    this.rowSpacing = 5.0,
  }) : super(key: key);

  @override
  State<ContributionGrid> createState() => _ContributionGridState();
}

class _ContributionGridState extends State<ContributionGrid> {
  late DateTime _today;
  late DateTime _startOfWindow;
  late DateTime _endOfWindow;
  late ScrollController _scrollController;

  final double _boxSize = 10;

  @override
  void initState() {
    super.initState();

    _today = DateTime.now();
    // Rolling 12-month window: always shows the past 365 days up to today.
    _startOfWindow = DateTime(_today.year, _today.month, _today.day)
        .subtract(const Duration(days: 364));
    _endOfWindow = DateTime(_today.year, _today.month, _today.day);
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentWeek();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final isDark = Get.isDarkMode;
  // ------------------ AUTO CENTER CURRENT WEEK ------------------
  void _scrollToCurrentWeek() {
    if (!_scrollController.hasClients) return;

    final int daysFromStart = _today.difference(_startOfWindow).inDays;
    final int currentWeekIndex = (daysFromStart / 7).floor();

    final double columnWidth = _boxSize + widget.columnSpacing;

    final double screenWidth = MediaQuery.of(context).size.width;

    final double targetOffset = (currentWeekIndex * columnWidth) -
        (screenWidth / 2) +
        (columnWidth / 2);

    _scrollController.animateTo(
      targetOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  // ------------------ BUILD UI ------------------
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

  // ------------------ GENERATE ROLLING 12-MONTH WINDOW ------------------
  List<Widget> _buildWeeks() {
    List<Widget> weeks = [];

    DateTime currentDate = _startOfWindow;

    // Align to Monday so each column starts on Mon
    if (currentDate.weekday != DateTime.monday) {
      currentDate =
          currentDate.subtract(Duration(days: currentDate.weekday - 1));
    }

    // End at the Sunday of the week that contains _endOfWindow
    DateTime lastWeekEnd = _endOfWindow;
    lastWeekEnd = lastWeekEnd.add(Duration(days: 7 - lastWeekEnd.weekday));

    while (!currentDate.isAfter(lastWeekEnd)) {
      weeks.add(_buildWeek(currentDate));
      currentDate = currentDate.add(const Duration(days: 7));
    }

    return weeks;
  }

  // ------------------ SINGLE WEEK COLUMN ------------------
  Widget _buildWeek(DateTime weekStart) {
    return Padding(
      padding: EdgeInsets.only(right: widget.columnSpacing),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(7, (index) {
          final DateTime dayDate = weekStart.add(Duration(days: index));

          final bool isCompleted = _isDateCompleted(dayDate);
          final bool isToday = _isToday(dayDate);
          final bool isFuture = dayDate.isAfter(_today);

          final SettingsController settingsController =
              Get.find<SettingsController>();

          return Padding(
            padding: EdgeInsets.only(bottom: widget.rowSpacing),
            child: Obx(() => Container(
                  width: _boxSize,
                  height: _boxSize,
                  decoration: BoxDecoration(
                    color: _getDayColor(
                      isCompleted,
                      isToday,
                      isFuture,
                    ),
                    borderRadius: BorderRadius.circular(2),

                    // 👇 ADD THIS
                    border: (isToday &&
                            settingsController.highlightCurrentDay.value)
                        ? Border.all(
                            color: isDark ? Colors.white : Colors.black,
                            width: 1, // thin border
                          )
                        : null,
                  ),
                )),
          );
        }),
      ),
    );
  }

  // ------------------ HELPERS ------------------
  bool _isDateCompleted(DateTime date) {
    return widget.completionDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  bool _isToday(DateTime date) {
    return date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;
  }

  Color _getDayColor(
    bool isCompleted,
    bool isToday,
    bool isFuture,
  ) {
    final Color base = widget.habitColor ?? Colors.green;

    if (isFuture) {
      return base.withValues(alpha: 0.1);
    } else if (isCompleted) {
      return base;
    } else if (isToday) {
      return base.withValues(alpha: 0.1);
    } else {
      return base.withValues(alpha: 0.15);
    }
  }
}
