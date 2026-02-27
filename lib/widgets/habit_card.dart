import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habit_chain/model/habit.dart';
import 'package:habit_chain/screens/add_habit.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/widgets/github_grid.dart';
import 'package:habit_chain/widgets/habit_header.dart';
import 'package:habit_chain/widgets/habit_progress_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HabitCard extends StatefulWidget {
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
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showActionMenu(BuildContext context) {
    HapticFeedback.mediumImpact();
    final habitController = Get.find<HabitController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.only(top: 12, bottom: 40),
          decoration: const BoxDecoration(
            color: Color(0xE61E2128), // Semi-transparent dark
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildActionItem(
                icon: widget.habit.isCompletedYesterday()
                    ? Icons.undo_rounded
                    : Icons.check_circle_outline_rounded,
                title: widget.habit.isCompletedYesterday()
                    ? 'Mark Yesterday as Incomplete'
                    : 'Mark Yesterday as Complete',
                onTap: () {
                  if (widget.habit.isCompletedYesterday()) {
                    habitController.uncompleteYesterday(widget.habit.id);
                  } else {
                    habitController.completeYesterday(widget.habit.id);
                  }
                  Get.back();
                },
              ),
              _buildActionItem(
                icon: Icons.reorder_rounded,
                title: 'Reorder Habit',
                onTap: () {
                  Get.back();
                  _showReorderBottomSheet(context);
                  HapticFeedback.selectionClick();
                },
              ),
              _buildActionItem(
                icon: Icons.share_rounded,
                title: 'Share Habit',
                onTap: () {
                  Get.back();
                  _shareHabit();
                },
              ),
              _buildActionItem(
                icon: Icons.edit_rounded,
                title: 'Edit Habit',
                onTap: () {
                  Get.back();
                  Get.to(() => AddHabitScreen(habit: widget.habit));
                },
              ),
              const Divider(color: Colors.white10, height: 1),
              _buildActionItem(
                icon: Icons.archive_outlined,
                title: 'Archive Habit',
                color: Colors.redAccent,
                onTap: () {
                  Get.back();
                  _showArchiveConfirmation(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReorderBottomSheet(BuildContext context) {
    final habitController = Get.find<HabitController>();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: Color(0xE61E2128),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Reorder Habits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() => ReorderableListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: habitController.habits.length,
                      onReorder: (oldIndex, newIndex) {
                        habitController.reorderHabits(oldIndex, newIndex);
                        HapticFeedback.selectionClick();
                      },
                      itemBuilder: (context, index) {
                        final habit = habitController.habits[index];
                        return Container(
                          key: ValueKey(habit.id),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: ListTile(
                            leading: Text(habit.emoji,
                                style: const TextStyle(fontSize: 24)),
                            title: Text(
                              habit.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            trailing: const Icon(Icons.drag_indicator_rounded,
                                color: Colors.white38),
                          ),
                        );
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? Colors.white).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showArchiveConfirmation(BuildContext context) {
    final habitController = Get.find<HabitController>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2128),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title:
            const Text('Archive Habit', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to archive "${widget.habit.name}"? It will be moved to the top and hidden from view unless pinned.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              habitController.toggleArchive(widget.habit.id);
              Get.back();
            },
            child: const Text('Archive',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  Future<void> _shareHabit() async {
    try {
      final image = await screenshotController.captureFromWidget(
        Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1115),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HabitHeaderWidget(
                  habit: widget.habit,
                  onComplete: () {},
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  child: ContributionGrid(
                    completionDates: widget.habit.completionDates,
                    habitColor: widget.habit.color,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.habit.currentStreak} Day Streak 🔥',
                      style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const Text(
                      'Habit Chain 🌱',
                      style: TextStyle(
                          color: Colors.white38,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/habit_achieve.png').create();
      await file.writeAsBytes(image);

      await Share.shareXFiles([XFile(file.path)],
          text:
              'My progress on ${widget.habit.name}! Still going strong with a ${widget.habit.currentStreak} day streak. #HabitChain');
    } catch (e) {
      Get.snackbar('Error', 'Could not share progress: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        // color: const Color(0xFF1E2128),
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFf0f0f0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.white10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => HabitProgressBottomSheet(
                habit: widget.habit,
                onHabitUpdated: widget.onHabitUpdated,
                onHabitDeleted: widget.onHabitDeleted,
                onComplete: widget.onComplete,
              ),
            );
          },
          onLongPress: () {
            _animationController.reverse();
            _showActionMenu(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HabitHeaderWidget(
                  habit: widget.habit,
                  onComplete: widget.onComplete,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 105,
                  child: ContributionGrid(
                    completionDates: widget.habit.completionDates,
                    habitColor: widget.habit.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
