import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:habit_chain/screens/emoji_selection_screen.dart';
import 'package:habit_chain/service/habit_service.dart';
import 'package:habit_chain/model/habit.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habit;
  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _targetCount = 1;
  Color _selectedColor = const Color(0xFF3A8DFF);
  String _selectedEmoji = '💪';
  bool _isGoodHabit = true;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _nameController.text = widget.habit!.name;
      _descriptionController.text = widget.habit!.description;
      _targetCount = widget.habit!.targetCount;
      _selectedColor = widget.habit!.color;
      _selectedEmoji = widget.habit!.emoji;
      _isGoodHabit = widget.habit!.isGoodHabit;
    }
  }

  final List<Color> _availableColors = [
    const Color(0xFF3A8DFF), // Premium Blue
    const Color(0xFF00D261), // Vibrant Green
    const Color(0xFFFF9F0A), // Warm Orange
    const Color(0xFFBF5AF2), // Purple
    const Color(0xFFFF375F), // Pinkish-Red
    const Color(0xFF64D2FF), // Sky Blue
    const Color(0xFF5E5CE6), // Indigo
    const Color(0xFFFFD60A), // Gold
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _buildSectionTitle('HABIT TYPE'),
                        _buildHabitTypeSelector(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('BASIC DETAILS'),
                        _buildBasicInfo(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('FREQUENCY'),
                        _buildTargetSelector(),
                        const SizedBox(height: 32),
                        _buildSectionTitle('APPEARANCE'),
                        _buildAppearanceCard(),
                        const SizedBox(height: 40),
                        _buildSaveButton(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2128),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2C313B)),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
            ),
          ),
          Text(
            widget.habit == null ? 'New Habit' : 'Edit Habit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 44), // To balance the back button
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildHabitTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2128),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2C313B)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeOption(
              'Build',
              true,
              const Color(0xFF3A8DFF),
            ),
          ),
          Expanded(
            child: _buildTypeOption(
              'Quit',
              false,
              const Color(0xFFFF375F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeOption(String label, bool isGood, Color activeColor) {
    final bool isSelected = _isGoodHabit == isGood;
    return GestureDetector(
      onTap: () => setState(() => _isGoodHabit = isGood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? activeColor.withValues(alpha: 0.5)
                : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? activeColor
                  : Colors.white.withValues(alpha: 0.5),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2128),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2C313B)),
      ),
      child: Column(
        children: [
          _buildTextField(
            controller: _nameController,
            hint: 'Habit name...',
            icon: Icons.edit_note,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Name is required' : null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: Color(0xFF2C313B), height: 1),
          ),
          _buildTextField(
            controller: _descriptionController,
            hint: 'Short description (optional)',
            icon: Icons.description_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 16),
        prefixIcon: Icon(icon,
            color: const Color(0xFF3A8DFF).withValues(alpha: 0.7), size: 22),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildTargetSelector() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2128),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2C313B)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Frequency',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A8DFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_targetCount days',
                  style: const TextStyle(
                      color: Color(0xFF3A8DFF), fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF3A8DFF),
              inactiveTrackColor: const Color(0xFF2C313B),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF3A8DFF).withValues(alpha: 0.12),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 10, elevation: 4),
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
              activeTickMarkColor: Colors.white.withValues(alpha: 0.5),
              inactiveTickMarkColor: Colors.white.withValues(alpha: 0.1),
            ),
            child: Slider(
              value: _targetCount.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              onChanged: (value) =>
                  setState(() => _targetCount = value.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2128),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2C313B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Theme Color',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          _buildColorPicker(),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF2C313B), height: 1),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Icon',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              _buildEmojiPickerButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _availableColors.map((color) {
        final bool isSelected = _selectedColor == color;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmojiPickerButton() {
    return GestureDetector(
      onTap: _openEmojiSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C313B).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2C313B)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selectedEmoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down,
                color: Colors.white.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3A8DFF).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _saveHabit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3A8DFF),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
        ),
        child: Text(
          widget.habit == null ? 'Create Habit' : 'Save Changes',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.2),
        ),
      ),
    );
  }

  void _openEmojiSelector() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EmojiSelectionScreen(
          currentEmoji: _selectedEmoji,
          onEmojiSelected: (emoji) {
            setState(() {
              _selectedEmoji = emoji;
            });
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutQuart;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final habitController = Get.find<HabitController>();

      if (widget.habit == null) {
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
        await habitController.addHabit(newHabit);
      } else {
        final updatedHabit = Habit(
          id: widget.habit!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          targetCount: _targetCount,
          currentCount: widget.habit!.currentCount,
          currentStreak: widget.habit!.currentStreak,
          longestStreak: widget.habit!.longestStreak,
          creationDate: widget.habit!.creationDate,
          completionDates: widget.habit!.completionDates,
          color: _selectedColor,
          emoji: _selectedEmoji,
          isGoodHabit: _isGoodHabit,
          isArchived: widget.habit!.isArchived,
          isPinned: widget.habit!.isPinned,
        );
        await habitController.updateHabit(updatedHabit);
      }
      Get.back(result: true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
