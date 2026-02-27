import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_chain/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class General extends StatefulWidget {
  const General({super.key});

  @override
  State<General> createState() => _GeneralState();
}

class SettingsController extends GetxController {
  var categoryFilter = true.obs;
  var highlightCurrentDay = false.obs;

  static const String _highlightKey = 'highlight_current_day';

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    highlightCurrentDay.value = prefs.getBool(_highlightKey) ?? false;
  }

  Future<void> toggleHighlight(bool value) async {
    highlightCurrentDay.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highlightKey, value);
  }
}

class _GeneralState extends State<General> with SingleTickerProviderStateMixin {
  bool _viewmodebtmbar = true;
  bool _streakCount = false;
  bool _streakGoal = false;
  bool _monthLabels = false;
  bool _daylabels = false;
  bool _categories = false;
  bool _crashlytics = false;
  late TabController _tabController;
  String _selectedDay = 'Monday';
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedDay = _days[_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final SettingsController settingsController =
        Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'General',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isDark ? MyColors.black : MyColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0.5, 0.1),
                        spreadRadius: 0.1,
                        blurRadius: 0.1,
                      )
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(24),
                                height: 320,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Week Starts On',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          icon: const Icon(Icons.close_rounded,
                                              size: 24),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    // Description
                                    Text(
                                      'Select the day of the week that starts the week',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                        height: 1.4,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // 7 Days Grid
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          _buildDayBox('Mon', 0),
                                          const SizedBox(width: 8),
                                          _buildDayBox('Tue', 1),
                                          const SizedBox(width: 8),
                                          _buildDayBox('Wed', 2),
                                          const SizedBox(width: 8),
                                          _buildDayBox('Thu', 3),
                                          const SizedBox(width: 8),
                                          _buildDayBox('Fri', 4),
                                          const SizedBox(width: 8),
                                          _buildDayBox('Sat', 5),
                                          const SizedBox(width: 8),
                                          _buildDayBox('Sun', 6),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Selected Day & Button
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Selected: $_selectedDay',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.primary,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shadowColor: Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            child: const Text(
                                              'Done',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Week Starts On $_selectedDay',
                                style: TextStyle(fontSize: 18),
                              ),
                              Icon(Icons.arrow_right)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Highlight current day',
                                style: TextStyle(fontSize: 18)),
                            Obx(() => Switch(
                                  activeTrackColor: MyColors.primary,
                                  focusColor: MyColors.white,
                                  activeColor: MyColors.white,
                                  value: settingsController
                                      .highlightCurrentDay.value,
                                  onChanged: (value) {
                                    settingsController.toggleHighlight(value);
                                  },
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ... rest of your existing containers and widgets remain the same
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark ? MyColors.black : MyColors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.5, 0.1),
                      spreadRadius: 0.1,
                      blurRadius: 0.1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show View Mode Bottom Bar',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: _viewmodebtmbar,
                              onChanged: (value) {
                                setState(() {
                                  _viewmodebtmbar = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
// With animation
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: _viewmodebtmbar
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Default Mode',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDark
                                        ? MyColors.white
                                        : MyColors.black,
                                  )),
                              Row(
                                children: [
                                  ToggleSwitch(
                                    initialLabelIndex: 0,
                                    totalSwitches: 3,
                                    inactiveFgColor: Colors.white,
                                    icons: const [
                                      Icons.list,
                                      Icons.view_compact,
                                      Icons.view_list_rounded,
                                    ],
                                    activeBgColors: const [
                                      [MyColors.primary],
                                      [MyColors.primary],
                                      [MyColors.primary],
                                    ],
                                    inactiveBgColor:
                                        Colors.grey.withValues(alpha: 0.2),
                                    onToggle: (index) {
                                      print('switched to: $index');
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        secondChild:
                            const SizedBox.shrink(), // Empty when hidden
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Category Filter',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: settingsController.categoryFilter.value,
                              onChanged: (value) {
                                setState(() {
                                  settingsController.categoryFilter.value =
                                      value;
                                  //_categoryFilter = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark ? MyColors.black : MyColors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.5, 0.1),
                      spreadRadius: 0.1,
                      blurRadius: 0.1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Streak Count',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: _streakCount,
                              onChanged: (value) {
                                setState(() {
                                  _streakCount = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Streak Goal',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: _streakGoal,
                              onChanged: (value) {
                                setState(() {
                                  _streakGoal = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Month Labels',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: _monthLabels,
                              onChanged: (value) {
                                setState(() {
                                  _monthLabels = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Day Labels',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: _daylabels,
                              onChanged: (value) {
                                setState(() {
                                  _daylabels = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Categories',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: _categories,
                              onChanged: (value) {
                                setState(() {
                                  _categories = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDark ? MyColors.black : MyColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.5, 0.1),
                      spreadRadius: 0.1,
                      blurRadius: 0.1,
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Allow Crashlytics',
                                style: TextStyle(fontSize: 18)),
                            Switch(
                              activeTrackColor: MyColors.primary,
                              focusColor: MyColors.white,
                              activeColor: MyColors.white,
                              value: _crashlytics,
                              onChanged: (value) {
                                setState(() {
                                  _crashlytics = value;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('RC ID', style: TextStyle(fontSize: 18)),
                            Icon(Icons.copy)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayBox(String day, int index) {
    bool isSelected = _selectedDay.substring(0, 3) == day;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDay = _days[index];
            _tabController.index = index;
          });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? MyColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? MyColors.primary : Colors.grey[300]!,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
