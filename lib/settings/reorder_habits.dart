import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habit_chain/service/habit_service.dart';

class ReorderHabits extends StatefulWidget {
  const ReorderHabits({super.key});

  @override
  State<ReorderHabits> createState() => _ReorderHabitsState();
}

class _ReorderHabitsState extends State<ReorderHabits> {
  @override
  Widget build(BuildContext context) {
    final HabitController habitController = Get.find<HabitController>();
    final isDark = Get.isDarkMode;

    return Scaffold(
      backgroundColor: context.theme.colorScheme.surface,
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
          'Reorder Habits',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      body: Obx(() {
        if (habitController.habits.isEmpty) {
          return Center(
            child: Text(
              'No habits to reorder',
              style: TextStyle(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.black.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Text(
                'Long-press and drag to reorder your habits',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.4)
                      : Colors.black.withValues(alpha: 0.4),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: habitController.habits.length,
                onReorder: (oldIndex, newIndex) {
                  habitController.reorderHabits(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final habit = habitController.habits[index];
                  return Container(
                    key: ValueKey(habit.id),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E2128) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2C313B)
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
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
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        habit.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.black.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                      trailing: Icon(
                        Icons.drag_indicator_rounded,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
