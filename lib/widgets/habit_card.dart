import 'package:flutter/material.dart';
import 'package:habit_chain/model/habit.dart';
import 'package:habit_chain/widgets/edit_habit.dart';
import 'package:habit_chain/widgets/github_grid.dart';
import 'package:habit_chain/widgets/habit_header.dart';
import 'package:habit_chain/widgets/habit_progress_bottom_sheet.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onDayTap;
  final Function(Habit)? onHabitUpdated;
  final VoidCallback? onHabitDeleted;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onTap,
    required this.onComplete,
    required this.onDayTap,
    this.onHabitUpdated,
    this.onHabitDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        //onTap: onTap,
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => HabitProgressBottomSheet(
              habit: habit,
              onHabitUpdated: onHabitUpdated,
              onHabitDeleted: onHabitDeleted,
              onComplete: onComplete,
            ),
          );
        },
        // onLongPress: () {
        //   showModalBottomSheet(
        //     context: context,
        //     isScrollControlled: true,
        //     backgroundColor: Colors.transparent,
        //     builder: (context) => EditHabitBottomSheet(
        //       habit: habit,
        //       onHabitUpdated: (updatedHabit) {
        //         if (onHabitUpdated != null) {
        //           onHabitUpdated!(updatedHabit);
        //         }
        //       },
        //     ),
        //   );
        // },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HabitHeaderWidget(
                habit: habit,
                onComplete: onComplete,
              ),
              // Row(
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         color: habit.color.withOpacity(0.2),
              //         shape: BoxShape.circle,
              //       ),
              //       child: Text(
              //         habit.emoji,
              //         style: const TextStyle(fontSize: 16),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             habit.name,
              //             style:
              //                 Theme.of(context).textTheme.titleMedium?.copyWith(
              //                       fontWeight: FontWeight.bold,
              //                     ),
              //           ),
              //           if (habit.description.isNotEmpty)
              //             Text(
              //               habit.description,
              //               style:
              //                   Theme.of(context).textTheme.bodySmall?.copyWith(
              //                         color: Theme.of(context).brightness ==
              //                                 Brightness.dark
              //                             ? Colors.grey[400]
              //                             : Colors.grey[600],
              //                       ),
              //             ),
              //         ],
              //       ),
              //     ),
              //     // Check Button
              //     GestureDetector(
              //       onTap: onComplete,
              //       child: Container(
              //         padding: const EdgeInsets.all(8),
              //         decoration: BoxDecoration(
              //           color: habit.isCompletedToday()
              //               ? habit.color
              //               : Theme.of(context).brightness == Brightness.dark
              //                   ? Colors.grey[700]!
              //                   : Colors.grey[300]!,
              //           shape: BoxShape.circle,
              //         ),
              //         child: Icon(
              //           Icons.check,
              //           color: habit.isCompletedToday()
              //               ? Colors.white
              //               : Theme.of(context).brightness == Brightness.dark
              //                   ? Colors.grey[400]!
              //                   : Colors.grey[600]!,
              //           size: 20,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 12),
              SizedBox(
                height: 135,
                child: ContributionGrid(
                  completionDates: habit.completionDates,
                  habitColor: habit.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
