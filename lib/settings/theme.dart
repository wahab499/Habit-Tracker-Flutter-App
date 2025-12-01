import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_chain/colors.dart';
import 'package:habit_chain/theme_provider.dart';

class Thememode extends StatelessWidget {
  const Thememode({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Theme',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(() {
        final currentTheme = themeController.themeMode;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      offset: const Offset(0.5, 0.1),
                      spreadRadius: 0.1,
                      blurRadius: 0.1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildThemeOption(
                        context: context,
                        title: 'System',
                        themeMode: ThemeMode.system,
                        currentTheme: currentTheme,
                        icon: Icons.brightness_auto,
                        onTap: () =>
                            themeController.setThemeMode(ThemeMode.system),
                      ),
                      _buildThemeOption(
                        context: context,
                        title: 'Light',
                        themeMode: ThemeMode.light,
                        currentTheme: currentTheme,
                        icon: Icons.light_mode,
                        onTap: () =>
                            themeController.setThemeMode(ThemeMode.light),
                      ),
                      _buildThemeOption(
                        context: context,
                        title: 'Dark',
                        themeMode: ThemeMode.dark,
                        currentTheme: currentTheme,
                        icon: Icons.dark_mode,
                        onTap: () =>
                            themeController.setThemeMode(ThemeMode.dark),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required ThemeMode themeMode,
    required ThemeMode currentTheme,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = currentTheme == themeMode;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? MyColors.blue // Selected icon - always blue
                      : (isDark
                          ? Colors.white
                          : Colors
                              .black), // Unselected icon - white in dark, black in light
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? MyColors.blue // Selected text - always blue
                        : (isDark
                            ? Colors.white
                            : Colors
                                .black), // Unselected text - white in dark, black in light
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: MyColors.blue, // Check icon - always blue when selected
              ),
          ],
        ),
      ),
    );
  }
}
