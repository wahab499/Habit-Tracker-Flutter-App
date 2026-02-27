import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/colors.dart';

class ArchivedHabits extends StatelessWidget {
  const ArchivedHabits({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController habitController = Get.find<HabitController>();
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1115) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Archived Habits',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Obx(() {
        final archived = habitController.archivedHabits;

        if (archived.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.archive_outlined,
                  size: 64,
                  color: isDark ? Colors.white24 : Colors.black12,
                ),
                const SizedBox(height: 16),
                Text(
                  'No archived habits',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          itemCount: archived.length,
          itemBuilder: (context, index) {
            final habit = archived[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E2128) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white10
                      : Colors.black.withValues(alpha: 0.05),
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    habit.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                title: Text(
                  habit.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Archived',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 12,
                  ),
                ),
                trailing: TextButton.icon(
                  onPressed: () {
                    habitController.toggleArchive(habit.id);
                    Get.snackbar(
                      'Restored',
                      '"${habit.name}" has been restored to Home.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: isDark ? Colors.white10 : Colors.black87,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(20),
                      borderRadius: 12,
                    );
                  },
                  icon: const Icon(Icons.unarchive_rounded, size: 18),
                  label: const Text('Restore'),
                  style: TextButton.styleFrom(
                    foregroundColor: MyColors.primary,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                          color: MyColors.primary.withValues(alpha: 0.2)),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
