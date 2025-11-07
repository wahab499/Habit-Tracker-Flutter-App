import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:habit_chain/colors.dart';
import 'package:habit_chain/settings/archived.dart';
import 'package:habit_chain/settings/dataimportexport.dart';
import 'package:habit_chain/settings/general.dart';
import 'package:habit_chain/settings/reorder_habits.dart';
import 'package:habit_chain/settings/theme.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: 320,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      MyColors.primary.withOpacity(0.2),
                      MyColors.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.settings,
                          size: 28, color: Colors.black87),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              _buildSettingTile(
                icon: Icons.tune,
                iconBgColor: Colors.blue,
                title: 'General',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const General()),
                  );
                },
              ),
              _buildSettingTile(
                icon: Icons.notifications_active,
                iconBgColor: Colors.orange,
                title: 'Daily Reminder',
                onTap: () => Navigator.of(context).maybePop(),
              ),
              _buildSettingTile(
                icon: Icons.palette,
                iconBgColor: Colors.purple,
                title: 'Theme',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Thememode()),
                  );
                },
              ),
              _buildSettingTile(
                icon: Icons.archive_outlined,
                iconBgColor: Colors.green,
                title: 'Archived Habits',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ArchivedHabits()),
                  );
                },
              ),
              _buildSettingTile(
                icon: Icons.import_export,
                iconBgColor: Colors.teal,
                title: 'Data Import / Export',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Dataimportexport()),
                  );
                },
              ),
              _buildSettingTile(
                icon: Icons.reorder,
                iconBgColor: Colors.pink,
                title: 'Reorder Habits',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReorderHabits()),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Help',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              _buildSettingTile(
                  icon: Icons.umbrella,
                  iconBgColor: Colors.orange,
                  title: 'Show Onboarding',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                              child: Text(
                                "Welcome to HabitFlow 🌱",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Center(
                              child: Text(
                                "Track, build, and maintain habits effortlessly!",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Feature 1
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    "✅ Build lasting habits with daily tracking and streaks.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Feature 2
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.notifications_active,
                                      color: Colors.amber),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    "🔔 Stay consistent with smart reminders and daily nudges.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Feature 3
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.insights,
                                      color: Colors.blue),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    "📊 Visualize your progress with beautiful analytics and charts.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Get Started",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  }),
              _buildSettingTile(
                  icon: Icons.note_add,
                  iconBgColor: Colors.blueAccent,
                  title: 'Show Whats New ',
                  onTap: () {}),
              _buildSettingTile(
                  icon: Icons.note_add,
                  iconBgColor: Colors.black,
                  title: 'Send feedback ',
                  onTap: () {}),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'About',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              _buildSettingTile(
                  icon: Icons.web,
                  iconBgColor: Colors.green,
                  title: 'Website ',
                  onTap: () {}),
              _buildSettingTile(
                  icon: Icons.no_accounts_outlined,
                  iconBgColor: Colors.blueAccent,
                  title: 'Follow on X',
                  onTap: () {}),
              _buildSettingTile(
                  icon: Icons.lock,
                  iconBgColor: Colors.pink,
                  title: 'Privacy Policy',
                  onTap: () {}),
              _buildSettingTile(
                  icon: Icons.no_accounts_outlined,
                  iconBgColor: Colors.green,
                  title: 'Terms of Use',
                  onTap: () {}),
              _buildSettingTile(
                  icon: Icons.star,
                  iconBgColor: Colors.purpleAccent,
                  title: 'Rate the app',
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildSettingTile({
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBgColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconBgColor),
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
}
