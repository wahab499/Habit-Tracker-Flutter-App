import 'package:flutter/material.dart';
import 'package:habit_chain/models/habit.dart';
import 'package:habit_chain/widget/streak_chain.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedToday();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with emoji, name, and completion indicator
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: habit.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child:
                        Text(habit.emoji, style: const TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isCompleted ? Colors.grey : null,
                                  ),
                        ),
                        if (habit.description.isNotEmpty)
                          Text(
                            habit.description,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                      ],
                    ),
                  ),
                  _buildCompletionIndicator(isCompleted),
                ],
              ),

              const SizedBox(height: 12),

              // Streak chain visualization
              StreakChain(habit: habit),

              const SizedBox(height: 8),

              // Progress and stats
              _buildProgressStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionIndicator(bool isCompleted) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isCompleted ? habit.color : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted ? habit.color : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: isCompleted
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  Widget _buildProgressStats() {
    return Row(
      children: [
        // Current streak
        _buildStatItem(
          Icons.local_fire_department,
          '${habit.currentStreak}',
          Colors.orange,
        ),

        const SizedBox(width: 16),

        // Weekly progress
        _buildStatItem(
          Icons.track_changes,
          '${habit.currentCount}/${habit.targetCount}',
          Colors.blue,
        ),

        const Spacer(),

        // Success rate
        _buildStatItem(
          Icons.trending_up,
          '${(habit.successRate * 100).toStringAsFixed(0)}%',
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
