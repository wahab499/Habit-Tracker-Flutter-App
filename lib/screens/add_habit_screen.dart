import 'package:flutter/material.dart';
import 'package:habit_chain/models/habit.dart';
import 'package:habit_chain/services/habit_services.dart';

class AddHabitScreen extends StatefulWidget {
  final HabitService habitService;

  const AddHabitScreen({Key? key, required this.habitService})
      : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _targetCount = 1;
  Color _selectedColor = Colors.blue;
  String _selectedEmoji = '💪';
  bool _isGoodHabit = true;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
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
    '🔥'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Habit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveHabit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHabitTypeSelector(),
              const SizedBox(height: 20),
              _buildBasicInfo(),
              const SizedBox(height: 20),
              _buildTargetSelector(),
              const SizedBox(height: 20),
              _buildColorSelector(),
              const SizedBox(height: 20),
              _buildEmojiSelector(),
              const Spacer(),
              _buildPreviewCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitTypeSelector() {
    return Card(
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

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Habit Name',
            border: OutlineInputBorder(),
            hintText: 'e.g., Morning Meditation',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a habit name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            border: OutlineInputBorder(),
            hintText: 'e.g., 10 minutes of mindfulness',
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildTargetSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target Frequency',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Times per week: $_targetCount'),
            const SizedBox(height: 8),
            Slider(
              value: _targetCount.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              onChanged: (value) =>
                  setState(() => _targetCount = value.toInt()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Color',
          style: Theme.of(context).textTheme.titleMedium,
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
      ],
    );
  }

  Widget _buildEmojiSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Emoji',
          style: Theme.of(context).textTheme.titleMedium,
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
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCard() {
    return Card(
      color: _selectedColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _selectedColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                _selectedEmoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text.isEmpty
                        ? 'Habit Name'
                        : _nameController.text,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (_descriptionController.text.isNotEmpty)
                    Text(
                      _descriptionController.text,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '$_targetCount×/week',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _isGoodHabit ? 'Build' : 'Break',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _isGoodHabit ? Colors.green : Colors.red,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildcard() {
    return Container();
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        targetCount: _targetCount,
        creationDate: DateTime.now(),
        color: _selectedColor,
        emoji: _selectedEmoji,
        isGoodHabit: _isGoodHabit,
      );

      widget.habitService.addHabit(newHabit);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
