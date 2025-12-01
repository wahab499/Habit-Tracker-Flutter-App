import 'package:flutter/material.dart';
import 'package:habit_chain/colors.dart';
import 'package:habit_chain/model/habit.dart';
import 'package:habit_chain/widgets/edit_habit.dart';
import 'package:habit_chain/widgets/github_grid.dart';
import 'package:habit_chain/widgets/habit_header.dart';

class HabitProgressBottomSheet extends StatefulWidget {
  final Habit habit;
  final Function(Habit)? onHabitUpdated;
  final VoidCallback? onHabitDeleted;
  final VoidCallback onComplete;

  const HabitProgressBottomSheet({
    Key? key,
    required this.habit,
    this.onHabitUpdated,
    this.onHabitDeleted,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<HabitProgressBottomSheet> createState() =>
      _HabitProgressBottomSheetState();
}

class _HabitProgressBottomSheetState extends State<HabitProgressBottomSheet> {
  late DateTime _currentMonth;

  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
  }

  void _showPreviousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _showNextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _showEditHabitSheet() {
    Navigator.pop(context); // Close current bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditHabitBottomSheet(
        habit: widget.habit,
        onHabitUpdated: (updatedHabit) {
          if (widget.onHabitUpdated != null) {
            widget.onHabitUpdated!(updatedHabit);
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content:
            Text('Are you sure you want to delete "${widget.habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              if (widget.onHabitDeleted != null) {
                widget.onHabitDeleted!();
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? MyColors.background : MyColors.white,
        //color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with habit info
          HabitHeaderWidget(
            habit: widget.habit,
            onComplete: widget.onComplete,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 135,
            child: ContributionGrid(
              completionDates: widget.habit.completionDates,
              habitColor: widget.habit.color,
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          _buildActionButtons(),
          const SizedBox(height: 24),

          // Month Calendar with swipe support
          _buildMonthCalendarWithSwipe(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showEditHabitSheet,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit Habit'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Add settings functionality here
            },
            icon: const Icon(Icons.settings, size: 18),
            label: const Text('Settings'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showDeleteConfirmation,
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCalendarWithSwipe() {
    return Expanded(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe right - go to previous month
          if (details.primaryVelocity! > 0) {
            _showPreviousMonth();
          }
          // Swipe left - go to next month
          else if (details.primaryVelocity! < 0) {
            _showNextMonth();
          }
        },
        child: Column(
          children: [
            // Month header with navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _showPreviousMonth,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: _showNextMonth,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Week days header
            Row(
              children: _weekDays.map((day) {
                return Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),

            // Calendar grid
            Expanded(
              child: _buildCalendarGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // Alternative approach with PageView for smoother transitions
  Widget _buildMonthCalendarWithPageView() {
    return Expanded(
      child: Column(
        children: [
          // Month header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _showPreviousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: _showNextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Week days header
          Row(
            children: _weekDays.map((day) {
              return Expanded(
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Calendar grid with swipe
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onHorizontalDragEnd: (details) {
                // Swipe right - go to previous month
                if (details.primaryVelocity! > 0) {
                  _showPreviousMonth();
                }
                // Swipe left - go to next month
                else if (details.primaryVelocity! < 0) {
                  _showNextMonth();
                }
              },
              child: _buildCalendarGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday;

    final totalCells = ((startingWeekday - 1) + daysInMonth);
    final totalRows = (totalCells / 7).ceil();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalRows,
      itemBuilder: (context, rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: List.generate(7, (columnIndex) {
              final cellIndex = (rowIndex * 7) + columnIndex;
              final dayNumber = cellIndex - (startingWeekday - 1) + 1;

              final isActualDay = dayNumber >= 1 && dayNumber <= daysInMonth;

              if (isActualDay) {
                final dayDate = DateTime(
                    _currentMonth.year, _currentMonth.month, dayNumber);
                return _buildCalendarDay(dayDate);
              } else {
                return _buildEmptyDay();
              }
            }),
          ),
        );
      },
    );
  }

  Widget _buildCalendarDay(DateTime date) {
    final isCompleted = _isDateCompleted(date);
    final isToday = _isToday(date);
    final isFutureDate = date.isAfter(DateTime.now());

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 36,
        decoration: BoxDecoration(
          color: _getDayColor(isCompleted, isToday, isFutureDate),
          borderRadius: BorderRadius.circular(6),
          border: isToday
              ? Border.all(
                  color: widget.habit.color,
                  width: 2,
                )
              : null,
        ),
        child: Center(
          child: Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getTextColor(isCompleted, isToday, isFutureDate),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyDay() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 36,
        color: Colors.transparent,
      ),
    );
  }

  bool _isDateCompleted(DateTime date) {
    return widget.habit.completionDates.any((completionDate) =>
        completionDate.year == date.year &&
        completionDate.month == date.month &&
        completionDate.day == date.day);
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  Color _getDayColor(bool isCompleted, bool isToday, bool isFutureDate) {
    if (isFutureDate) {
      return Colors.grey[50]!;
    } else if (isCompleted) {
      return widget.habit.color.withValues(alpha: 0.8);
    } else if (isToday) {
      return widget.habit.color.withValues(alpha: 0.2);
    } else {
      return Colors.grey[100]!;
    }
  }

  Color _getTextColor(bool isCompleted, bool isToday, bool isFutureDate) {
    if (isFutureDate) {
      return Colors.black.withValues(alpha: 0.5);
    } else if (isCompleted) {
      return Colors.white;
    } else if (isToday) {
      return widget.habit.color;
    } else {
      return Colors.grey[600]!;
    }
  }
}
