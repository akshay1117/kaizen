import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/services/design_tokens.dart';
import 'package:optimos/view/widget/color_picker_grid.dart';
import 'package:optimos/view/widget/custom_option_tile.dart';
import 'package:optimos/view/widget/icon_picker_grid.dart';
import 'package:optimos/view/widget/tracking_segmented_control.dart';
import 'package:optimos/view/widget/category_wrap.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController(); // We map description to note or ignore if no schema field, but let's keep it in UI
  
  String _iconName = 'favorite';
  IconData _iconData = Icons.favorite_border;
  
  Color _color = const Color(0xFFFF4D4D);
  final String _frequency = 'daily';
  String? _reminder;
  bool _isQuantitative = false;
  int _targetValue = 1;
  final String _unit = '';
  
  String _streakGoal = 'None';
  final List<String> _categories = [];
  bool _showAdvanced = false;

  final List<Color> _colors = [
    const Color(0xFFFF6B6B), const Color(0xFFFF922B), const Color(0xFFFCC419), const Color(0xFFFFE066),
    const Color(0xFF94D82D), const Color(0xFF51CF66), const Color(0xFF20C997), const Color(0xFF339AF0),
    const Color(0xFF3BC9DB), const Color(0xFF4DABF7), const Color(0xFF748FFC), const Color(0xFF9775FA),
    const Color(0xFFB197FC), const Color(0xFFE599F7), const Color(0xFFF06595), const Color(0xFFFFA8A8),
    const Color(0xFFFF8787), const Color(0xFFADB5BD), const Color(0xFF868E96), const Color(0xFF495057),
  ];

  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'wallet', 'icon': Icons.account_balance_wallet_outlined},
    {'name': 'moon', 'icon': Icons.nights_stay_outlined},
    {'name': 'camera', 'icon': Icons.camera_alt_outlined},
    {'name': 'coffee', 'icon': Icons.local_cafe_outlined},
    {'name': 'fitness', 'icon': Icons.fitness_center_outlined},
    {'name': 'book', 'icon': Icons.menu_book_outlined},
    {'name': 'medication', 'icon': Icons.medication_outlined},
    {'name': 'water', 'icon': Icons.water_drop_outlined},
    {'name': 'favorite', 'icon': Icons.favorite_border},
    {'name': 'restaurant', 'icon': Icons.restaurant_menu_outlined},
    {'name': 'directions_run', 'icon': Icons.directions_run_outlined},
    {'name': 'laptop', 'icon': Icons.laptop_mac_outlined},
  ];

  final List<String> _allCategories = [
    'Art', 'Finances', 'Fitness', 'Health', 'Nutrition', 'Social', 'Study', 'Work', 'Morning', 'Day', 'Evening'
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _showIconPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: DesignTokens.bgSecondary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: DesignTokens.borderSecondary, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              IconPickerGrid(
                selectedIcon: _iconName,
                icons: _availableIcons,
                onIconSelected: (name) {
                  setState(() {
                    _iconName = name;
                    _iconData = _availableIcons.firstWhere((e) => e['name'] == name)['icon'];
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showStreakGoalPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignTokens.bgSecondary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: ['None', 'Daily', 'Week', 'Month'].map((goal) {
            return ListTile(
              title: Text(goal, style: const TextStyle(color: DesignTokens.textPrimary)),
              trailing: _streakGoal == goal ? const Icon(Icons.check, color: Colors.white) : null,
              onTap: () {
                setState(() => _streakGoal = goal);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: DesignTokens.bgSecondary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(alignment: Alignment.center, child: Container(width: 40, height: 4, decoration: BoxDecoration(color: DesignTokens.borderSecondary, borderRadius: BorderRadius.circular(2)))),
                    const SizedBox(height: 24),
                    Text('Categories', style: Theme.of(context).textTheme.displaySmall),
                    const SizedBox(height: 8),
                    Text('Pick one or multiple categories that your habit fits in', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    CategoryWrap(
                      availableCategories: _allCategories,
                      selectedCategories: _categories,
                      onToggleCategory: (cat) {
                        setModalState(() {
                          if (_categories.contains(cat)) {
                            _categories.remove(cat);
                          } else {
                            _categories.add(cat);
                          }
                        });
                        setState(() {});
                      },
                      onCreateNew: () {
                        // Dummy for now
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignTokens.accentDiet,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DesignTokens.radiusMedium)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignTokens.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DesignTokens.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('New Habit', style: Theme.of(context).textTheme.displaySmall),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  children: [
                    // Icon Picker
                    Center(
                      child: GestureDetector(
                        onTap: _showIconPicker,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: DesignTokens.bgSecondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_iconData, size: 40, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Name
                    Text('Name', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(),
                      style: const TextStyle(color: Colors.white),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    
                    // Description
                    Text('Description', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    
                    // Color Picker
                    Text('Color', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 12),
                    ColorPickerGrid(
                      colors: _colors,
                      selectedColor: _color,
                      onColorSelected: (c) => setState(() => _color = c),
                    ),
                    const SizedBox(height: 32),
                    
                    // Advanced Options Toggle
                    GestureDetector(
                      onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Advanced Options', style: Theme.of(context).textTheme.bodyMedium),
                          Icon(_showAdvanced ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: DesignTokens.textSecondary, size: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    AnimatedCrossFade(
                      firstChild: const SizedBox(width: double.infinity),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Streak Goal', style: Theme.of(context).textTheme.labelMedium),
                                    const SizedBox(height: 8),
                                    CustomOptionTile(
                                      title: 'Streak Goal',
                                      subtitle: _streakGoal,
                                      onTap: _showStreakGoalPicker,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Reminder', style: Theme.of(context).textTheme.labelMedium),
                                    const SizedBox(height: 8),
                                    CustomOptionTile(
                                      title: 'Reminder',
                                      subtitle: _reminder ?? '0 Active Reminders',
                                      onTap: () async {
                                        final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                        if (time != null) {
                                          setState(() => _reminder = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          Text('Categories', style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 8),
                          CustomOptionTile(
                            title: 'Categories',
                            subtitle: _categories.isEmpty ? 'None' : _categories.join(', '),
                            onTap: _showCategoryPicker,
                          ),
                          const SizedBox(height: 24),
                          
                          Text('How should completions be tracked?', style: Theme.of(context).textTheme.labelMedium),
                          const SizedBox(height: 8),
                          TrackingSegmentedControl(
                            isQuantitative: _isQuantitative,
                            onChanged: (val) => setState(() => _isQuantitative = val),
                          ),
                          const SizedBox(height: 24),
                          
                          if (_isQuantitative) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Completions Per Day', style: Theme.of(context).textTheme.labelMedium),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: DesignTokens.bgTertiary,
                                      borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
                                    ),
                                    child: Text('$_targetValue / Day', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildActionButton(Icons.remove, () {
                                  if (_targetValue > 1) setState(() => _targetValue--);
                                }),
                                const SizedBox(width: 8),
                                _buildActionButton(Icons.add, () {
                                  setState(() => _targetValue++);
                                }),
                                const SizedBox(width: 8),
                                _buildActionButton(Icons.edit_outlined, () {
                                  // Edit custom unit or exact value logic
                                }),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text('The square will be filled completely when this number is met', style: Theme.of(context).textTheme.labelMedium),
                            ),
                            const SizedBox(height: 48),
                          ]
                        ],
                      ),
                      crossFadeState: _showAdvanced ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DesignTokens.accentDiet, // Purple button from screenshot
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _save,
                    child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: DesignTokens.bgTertiary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      final hexColor = '#${_color.toARGB32().toRadixString(16).substring(2, 8).toUpperCase()}';
      await ref.read(habitNotifierProvider.notifier).addHabit(
            name: _nameCtrl.text,
            icon: _iconName,
            color: hexColor,
            frequency: _frequency,
            reminderTime: _reminder,
            isQuantitative: _isQuantitative,
            targetValue: _targetValue,
            unit: _unit.isEmpty ? null : _unit,
            categories: _categories.isNotEmpty ? _categories.join(',') : null,
            streakGoalInterval: _streakGoal.toLowerCase(),
          );
      if (mounted) {
        context.pop();
      }
    }
  }
}