import 'package:flutter/material.dart';
import 'package:habit_chain/colors.dart';
import 'package:habit_chain/screens/add_habit.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/settings/archived.dart';
import 'package:habit_chain/settings/general.dart';
import 'package:habit_chain/settings/theme.dart';
import 'package:habit_chain/widgets/habit_card.dart';

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
      endDrawer: SafeArea(
        child: SizedBox(
          width: 320,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration:
                      BoxDecoration(color: MyColors.primary.withOpacity(0.1)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(Icons.settings, size: 28),
                      SizedBox(width: 12),
                      Text('Settings',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.tune),
                  title: const Text('General'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => General()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_active),
                  title: const Text('Daily Reminder'),
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Theme'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Thememode()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: const Text('Archived Habit'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArchivedHabits()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.import_export),
                  title: const Text('Data Import Export'),
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.reorder),
                  title: const Text('Reorder Habit'),
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
