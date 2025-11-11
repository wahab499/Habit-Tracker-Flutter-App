import 'package:flutter/material.dart';
import 'package:habit_chain/model/habit.dart';
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
