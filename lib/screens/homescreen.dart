import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_chain/colors.dart';
import 'package:habit_chain/model/habit.dart';
import 'package:habit_chain/screens/add_habit.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/settings/general.dart';
import 'package:habit_chain/widgets/habit_card.dart';
import 'package:habit_chain/widgets/settings_drawer.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HabitController habitController = Get.find<HabitController>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final SettingsController settingsController =
        Get.find<SettingsController>();

    void _updateHabit(Habit updatedHabit) async {
      await habitController.updateHabit(updatedHabit);
    }

    void _deleteHabit(String habitId) async {
      await habitController.deleteHabit(habitId);
    }

    void _completeHabit(Habit habit) async {
      final isCompletedToday = habit.isCompletedToday();

      if (isCompletedToday) {
        await habitController.markHabitUncompleted(habit.id);
      } else {
        await habitController.markHabitCompleted(habit.id);
      }
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
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
              onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
              tooltip: 'Settings',
            ),
          ],
        ),
        endDrawer: SettingsDrawer(),
        body: Stack(
          children: [
            Obx(() {
              if (habitController.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (habitController.habits.isEmpty) {
                return _buildEmptyState(context);
              }

              return _buildHabitsList(context, habitController, _updateHabit,
                  _deleteHabit, _completeHabit);
            }),

            // Floating ToggleSwitch at bottom center
            Positioned(
              bottom: 20, // Adjust position as needed
              left: 0,
              right: 0,
              child: Obx(() {
                if (habitController.habits.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Obx(() {
                          if (!settingsController.categoryFilter.value)
                            return SizedBox.shrink();
                          return ToggleSwitch(
                            initialLabelIndex: 0,
                            totalSwitches: 3,
                            inactiveFgColor: Colors.white,
                            icons: const [
                              Icons.list,
                              Icons.view_compact,
                              Icons.view_list_rounded,
                            ],
                            activeBgColors: const [
                              [Colors.blue],
                              [Colors.blue],
                              [Colors.blue],
                            ],
                            onToggle: (index) {
                              print('switched to: $index');
                              // Add your view mode logic here
                            },
                          );
                        })
                        // child: ToggleSwitch(
                        //   initialLabelIndex: 0,
                        //   totalSwitches: 3,
                        //   inactiveFgColor: Colors.white,
                        //   icons: const [
                        //     Icons.list,
                        //     Icons.view_compact,
                        //     Icons.view_list_rounded,
                        //   ],
                        //   activeBgColors: const [
                        //     [Colors.blue],
                        //     [Colors.blue],
                        //     [Colors.blue],
                        //   ],
                        //   onToggle: (index) {
                        //     print('switched to: $index');
                        //     // Add your view mode logic here
                        //   },
                        // ),
                        ),
                  ),
                );
              }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Get.to(() => const AddHabitScreen());
            if (result == true) {
              habitController.loadHabits();
            }
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );

    // return SafeArea(
    //   child: Scaffold(
    //     key: scaffoldKey,
    //     appBar: AppBar(
    //       title: const Text(
    //         'Habit Chain',
    //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    //       ),
    //       centerTitle: true,
    //       backgroundColor: MyColors.primary,
    //       actions: [
    //         IconButton(
    //           icon: const Icon(
    //             Icons.settings,
    //             color: Colors.white,
    //           ),
    //           onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
    //           tooltip: 'Settings',
    //         ),
    //       ],
    //     ),
    //     endDrawer: SettingsDrawer(),
    //     body: Obx(() {
    //       if (habitController.isLoading) {
    //         return const Center(child: CircularProgressIndicator());
    //       }

    //       if (habitController.habits.isEmpty) {
    //         return _buildEmptyState(context);
    //       }

    //       return _buildHabitsList(context, habitController, _updateHabit,
    //           _deleteHabit, _completeHabit);
    //     }),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () async {
    //         final result = await Get.to(() => const AddHabitScreen());
    //         if (result == true) {
    //           habitController.loadHabits();
    //         }
    //       },
    //       child: const Icon(Icons.add),
    //     ),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    //   ),
    // );
  }

  Widget _buildEmptyState(BuildContext context) {
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

  Widget _buildHabitsList(
    BuildContext context,
    HabitController habitController,
    Function(Habit) updateHabit,
    Function(String) deleteHabit,
    Function(Habit) completeHabit,
  ) {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: habitController.habits.length,
        itemBuilder: (context, index) {
          final habit = habitController.habits[index];
          return HabitCard(
            habit: habit,
            onTap: () {
              // Handle tap on habit card (maybe show details)
              print('Tapped on ${habit.name}');
            },
            onComplete: () => completeHabit(habit),
            onDayTap: () {
              // Handle day tap in the grid if needed
            },
            onHabitUpdated: updateHabit,
            onHabitDeleted: () => deleteHabit(habit.id),
          );
        },
      );
    });
  }
}
