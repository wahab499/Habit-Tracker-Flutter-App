import 'package:flutter/material.dart';
import 'package:habit_chain/model/habit.dart';

class EditHabitBottomSheet extends StatefulWidget {
  final Habit habit;
  final Function(Habit) onHabitUpdated;

  const EditHabitBottomSheet({
    Key? key,
    required this.habit,
    required this.onHabitUpdated,
  }) : super(key: key);

  @override
  State<EditHabitBottomSheet> createState() => _EditHabitBottomSheetState();
}

class _EditHabitBottomSheetState extends State<EditHabitBottomSheet> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late int _targetCount;
  late Color _selectedColor;
  late String _selectedEmoji;
  late bool _isGoodHabit;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  final List<String> _availableEmojis = [
    '💪',
    '📚',
    '🏃',
    '🧘',
    '💧',
    '🥗',
    '😴',
    '🎯',
    '⭐',
    '🔥',
    '🚀',
    '🌈',
    '🎨',
    '🎵',
    '🏆',
    '💡',
    '🔔',
    '🕰️',
    '🌱',
    '💎'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _descriptionController =
        TextEditingController(text: widget.habit.description);
    _targetCount = widget.habit.targetCount;
    _selectedColor = widget.habit.color;
    _selectedEmoji = widget.habit.emoji;
    _isGoodHabit = widget.habit.isGoodHabit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedHabit = Habit(
      id: widget.habit.id,
      name: _nameController.text,
      description: _descriptionController.text,
      targetCount: _targetCount,
      currentCount: widget.habit.currentCount,
      currentStreak: widget.habit.currentStreak,
      longestStreak: widget.habit.longestStreak,
      creationDate: widget.habit.creationDate,
      completionDates: widget.habit.completionDates,
      color: _selectedColor,
      emoji: _selectedEmoji,
      isGoodHabit: _isGoodHabit,
    );

    widget.onHabitUpdated(updatedHabit);
    Navigator.pop(context);
  }

  // void _deleteHabit() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Delete Habit'),
  //       content:
  //           Text('Are you sure you want to delete "${widget.habit.name}"?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context); // Close dialog
  //             Navigator.pop(context); // Close bottom sheet
  //             if (widget.onHabitDeleted != null) {
  //               widget.onHabitDeleted!();
  //             }
  //           },
  //           child: const Text(
  //             'Delete',
  //             style: TextStyle(color: Colors.red),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
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
          const SizedBox(height: 16),
          const Row(
            children: [
              Text(
                'Edit Habit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Habit Name
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Habit Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // Description
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Target Frequency
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Target Frequency',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Times per week: $_targetCount'),
                  const SizedBox(height: 8),
                  Slider(
                    value: _targetCount.toDouble(),
                    min: 1,
                    max: 7,
                    divisions: 6,
                    onChanged: (value) {
                      setState(() => _targetCount = value.toInt());
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Color Selection
          const Text(
            'Color',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableColors.length,
              itemBuilder: (context, index) {
                final color = _availableColors[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _selectedColor == color
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Emoji Selection
          const Text(
            'Emoji',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableEmojis.length,
              itemBuilder: (context, index) {
                final emoji = _availableEmojis[index];
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _selectedEmoji == emoji
                          ? _selectedColor.withOpacity(0.2)
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Habit Type
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildHabitTypeOption(
                      'Good Habit',
                      Icons.thumb_up,
                      Colors.green,
                      true,
                    ),
                  ),
                  Expanded(
                    child: _buildHabitTypeOption(
                      'Bad Habit',
                      Icons.thumb_down,
                      Colors.red,
                      false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Changes'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHabitTypeOption(
      String title, IconData icon, Color color, bool isGood) {
    return GestureDetector(
      onTap: () => setState(() => _isGoodHabit = isGood),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isGoodHabit == isGood
              ? color.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isGoodHabit == isGood ? color : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
