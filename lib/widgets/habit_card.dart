// // widgets/habit_card.dart
// import 'package:flutter/material.dart';
// import 'package:habit_chain/model/habit.dart';

// class HabitCard extends StatelessWidget {
//   final Habit habit;
//   final VoidCallback onTap;
//   final VoidCallback onComplete;

//   const HabitCard({
//     Key? key,
//     required this.habit,
//     required this.onTap,
//     required this.onComplete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final progress = habit.currentCount / habit.targetCount;

//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: habit.color.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Text(
//                       habit.emoji,
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           habit.name,
//                           style:
//                               Theme.of(context).textTheme.titleMedium?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                         ),
//                         if (habit.description.isNotEmpty)
//                           Text(
//                             habit.description,
//                             style:
//                                 Theme.of(context).textTheme.bodySmall?.copyWith(
//                                       color: Colors.grey[600],
//                                     ),
//                           ),
//                       ],
//                     ),
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         '${habit.currentCount}/${habit.targetCount}',
//                         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                       ),
//                       SizedBox(height: 4),
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: habit.isGoodHabit
//                               ? Colors.green.withOpacity(0.1)
//                               : Colors.red.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           habit.isGoodHabit ? 'Build' : 'Break',
//                           style:
//                               Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     color: habit.isGoodHabit
//                                         ? Colors.green
//                                         : Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               // Progress bar
//               LinearProgressIndicator(
//                 value: progress,
//                 backgroundColor: Colors.grey[200],
//                 color: habit.color,
//                 minHeight: 6,
//                 borderRadius: BorderRadius.circular(3),
//               ),
//               SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '${(progress * 100).toStringAsFixed(0)}%',
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                   ElevatedButton(
//                     onPressed: onComplete,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: habit.color,
//                       foregroundColor: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                     ),
//                     child: Text(
//                       habit.isCompletedToday() ? 'Completed' : 'Mark Done',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
