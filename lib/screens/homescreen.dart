import 'package:flutter/material.dart';
import 'package:habit_chain/colors.dart';
import 'package:habit_chain/screens/add_habit.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/widgets/habit_card.dart';
import 'package:habit_chain/widgets/settings_drawer.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final HabitService _habitService = HabitService();
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    await _habitService.loadHabits();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Habit Chain',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: MyColors.primary,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            tooltip: 'Settings',
          ),
        ],
      ),
      endDrawer: const SettingsDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _habitService.habits.isEmpty
              ? _buildEmptyState()
              : _buildHabitsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHabitScreen(habitService: _habitService),
            ),
          );
          if (result == true) {
            _loadHabits();
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.track_changes,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No habits yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first habit',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _habitService.habits.length,
      itemBuilder: (context, index) {
        final habit = _habitService.habits[index];
        return HabitCard(
          habit: habit,
          onTap: () {
            // Navigate to habit details if needed
          },
          onComplete: () async {
            if (habit.isCompletedToday()) {
              await _habitService.markHabitUncompleted(habit.id);
            } else {
              await _habitService.markHabitCompleted(habit.id);
            }
            setState(() {});
          },
          onDayTap: () {
            // Handle day tap for progress grid
          },
        );
      },
    );
  }
}

Widget _buildSettingTile({
  required IconData icon,
  required Color iconBgColor,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconBgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.black87),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    onTap: onTap,
  );
}
