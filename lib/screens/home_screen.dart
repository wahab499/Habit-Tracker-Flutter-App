import 'dart:math';
import 'package:flutter/material.dart';
import 'package:habit_chain/models/habit.dart';
import 'package:habit_chain/screens/add_habit_screen.dart';
import 'package:habit_chain/widget/githubgrid.dart';
import 'package:habit_chain/services/habit_services.dart';
import 'package:habit_chain/widget/habit_card.dart';

class HomeScreen extends StatefulWidget {
  final HabitService habitService;

  const HomeScreen({Key? key, required this.habitService}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final rnd = Random(42);
final weeks = 52;
final data = List.generate(weeks * 7, (_) => rnd.nextInt(20));

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Chain'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.analytics),
        //     onPressed: _showStatistics,
        //   ),
        // ],
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.habitService,
        builder: (context, _, __) {
          if (widget.habitService.habits.isEmpty) {
            return _buildEmptyState();
          }
          return _buildHabitList();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewHabit,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.psychology_alt, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No habits yet!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Start building your chain by adding your first habit',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHabitList() {
    return Column(
      children: [
        // Quick Stats
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Streak',
                  '${widget.habitService.getTotalStreak()}',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Success Rate',
                  '${(widget.habitService.getOverallSuccessRate() * 100).toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 210,
            width: 390,
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContributionGrid(
                                      weeks: weeks, values: data)));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.amber.shade200,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 1, color: Colors.amber)),
                          child: Icon(Icons.power),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: Colors.amber)),
                        child: Icon(Icons.check),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ContributionGrid(
                          weeks: weeks,
                          values: data,
                          estimatedVisibleColumns: 29,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Habits List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: widget.habitService.habits.length,
            itemBuilder: (context, index) {
              final habit = widget.habitService.habits[index];
              return GithubHabitCard(
                habit: habit,
                onTap: () => _toggleHabitCompletion(habit),
                onLongPress: () => _showHabitOptions(habit),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewHabit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddHabitScreen(habitService: widget.habitService),
      ),
    );
  }

  void _toggleHabitCompletion(Habit habit) {
    final isCompleted = habit.isCompletedToday();
    widget.habitService.markHabitCompleted(habit.id, completed: !isCompleted);

    // Show celebration for completing a habit
    if (!isCompleted) {
      _showCompletionCelebration(habit);
    }
  }

  void _showCompletionCelebration(Habit habit) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text('${habit.emoji} ${habit.name} completed!'),
            const SizedBox(width: 8),
            const Icon(Icons.celebration, color: Colors.yellow),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showHabitOptions(Habit habit) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete Habit'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteHabit(habit);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Habit'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement edit functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteHabit(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.habitService.deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // void _showStatistics() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => StatisticsCard(habitService: widget.habitService),
  //   );
  // }
}
