import 'package:flutter/material.dart';
import 'package:habit_chain/models/habit.dart';

class StreakChain extends StatelessWidget {
  final Habit habit;

  const StreakChain({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentStreak = habit.currentStreak;
    final maxVisibleLinks = 10; // Maximum links to show horizontally

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Streak: $currentStreak days',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 8),

        // Fixed: Proper conditional rendering
        if (currentStreak == 0) _buildEmptyChain(),
        if (currentStreak > 0 && currentStreak <= maxVisibleLinks)
          _buildHorizontalChain(currentStreak),
        if (currentStreak > maxVisibleLinks)
          _buildCompressedChain(currentStreak),
      ],
    );
  }

  Widget _buildEmptyChain() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        'Start your chain! Complete this habit today.',
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
    );
  }

  Widget _buildHorizontalChain(int streakLength) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: streakLength,
        itemBuilder: (context, index) {
          return _buildChainLink(index == streakLength - 1);
        },
      ),
    );
  }

  Widget _buildCompressedChain(int streakLength) {
    return Row(
      children: [
        // Show first few links
        for (int i = 0; i < 3; i++) _buildChainLink(false),

        // Show ellipsis
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            '···',
            style: TextStyle(color: habit.color, fontSize: 16),
          ),
        ),

        // Show last few links
        for (int i = streakLength - 3; i < streakLength; i++)
          _buildChainLink(i == streakLength - 1),

        // Show streak count
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '$streakLength',
            style: TextStyle(
              color: habit.color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChainLink(bool isLatest) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: isLatest ? habit.color : habit.color.withOpacity(0.6),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: habit.color.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: isLatest
          ? const Icon(Icons.celebration, size: 12, color: Colors.white)
          : const Icon(Icons.check, size: 12, color: Colors.white),
    );
  }
}
