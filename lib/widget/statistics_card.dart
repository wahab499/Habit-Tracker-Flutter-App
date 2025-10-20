// import 'package:flutter/material.dart';
// import 'package:habit_chain/models/habit.dart';
// import 'package:habit_chain/services/habit_services.dart';

// class StatisticsCard extends StatelessWidget {
//   final HabitService habitService;

//   const StatisticsCard({Key? key, required this.habitService})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final habits = habitService.habits;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Your Habit Statistics',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),

//           // Overall stats
//           _buildOverallStats(),
//           const SizedBox(height: 20),

//           // Habit-specific stats
//           Expanded(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: habits.length,
//               itemBuilder: (context, index) {
//                 return _buildHabitStat(habits[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverallStats() {
//     final totalStreak = habitService.getTotalStreak();
//     final successRate = habitService.getOverallSuccessRate();

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             _buildStatCircle(
//               'Total Streak',
//               '$totalStreak',
//               Icons.local_fire_department,
//               Colors.orange,
//             ),
//             const SizedBox(width: 20),
//             _buildStatCircle(
//               'Success Rate',
//               '${(successRate * 100).toStringAsFixed(1)}%',
//               Icons.trending_up,
//               Colors.green,
//             ),
//             const SizedBox(width: 20),
//             _buildStatCircle(
//               'Active Habits',
//               '${habitService.habits.length}',
//               Icons.psychology,
//               Colors.blue,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCircle(
//       String label, String value, IconData icon, Color color) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               shape: BoxShape.circle,
//               border: Border.all(color: color.withOpacity(0.3)),
//             ),
//             child: Icon(icon, color: color, size: 24),
//           ),
//           const SizedBox(height: 8),
//           Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 12, color: Colors.grey),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHabitStat(Habit habit) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: habit.color.withOpacity(0.2),
//                 shape: BoxShape.circle,
//               ),
//               child: Text(habit.emoji),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(habit.name,
//                       style: const TextStyle(fontWeight: FontWeight.w500)),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${habit.currentStreak} day streak • ${(habit.successRate * 100).toStringAsFixed(0)}% success',
//                     style: const TextStyle(fontSize: 12, color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             LinearProgressIndicator(
//               value: habit.successRate,
//               backgroundColor: Colors.grey[200],
//               color: habit.color,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
