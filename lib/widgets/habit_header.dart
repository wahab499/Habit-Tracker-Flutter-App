import 'package:flutter/material.dart';
import 'package:habit_chain/colors.dart';
import 'package:habit_chain/model/habit.dart';

class HabitHeaderWidget extends StatelessWidget {
  final Habit habit;
  final VoidCallback onComplete;

  const HabitHeaderWidget({
    Key? key,
    required this.habit,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: habit.color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            habit.emoji,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? MyColors.white : MyColors.white,
                    ),
              ),
              if (habit.description.isNotEmpty)
                Text(
                  habit.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                      ),
                ),
            ],
          ),
        ),
        // Check Button
        GestureDetector(
          onTap: onComplete,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: habit.isCompletedToday()
                  ? habit.color
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: habit.isCompletedToday()
                  ? Colors.white
                  : Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[400]!
                      : Colors.grey[600]!,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
