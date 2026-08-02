import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaizen/controller/habit_providers.dart';
import 'package:kaizen/services/design_tokens.dart';
import 'package:kaizen/view/widget/tracking_segmented_control.dart';
import 'package:kaizen/view/widget/category_wrap.dart';
import 'package:kaizen/view/screen/streak_goal_screen.dart';
import 'package:kaizen/view/screen/reminder_screen.dart';
import 'package:kaizen/view/widget/icon_picker_sheet.dart';
import 'package:kaizen/utils/habit_icons.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  
  Color _color = const Color(0xFFF76C6C); // Default to first color
  String _iconId = 'pulse'; // Default icon id from Sports
  
  final String _frequency = 'daily';
  String? _reminder;
  bool _isQuantitative = false;
  int _targetValue = 1;
  final String _unit = '';
  
  String _streakGoal = 'None';
  final List<String> _categories = [];
  bool _showAdvanced = false;

  final List<Color> _colors = [
    // Row 1
    const Color(0xFFF76C6C), const Color(0xFFF5A623), const Color(0xFFF7B733), const Color(0xFFF9D423), 
    const Color(0xFF8BC34A), const Color(0xFF4CAF50), const Color(0xFF26C281),
    // Row 2
    const Color(0xFF1ABC9C), const Color(0xFF26C6DA), const Color(0xFF29B6F6), const Color(0xFF5B9BF0), 
    const Color(0xFF7C83F0), const Color(0xFFB784E0), const Color(0xFFC97FE8),
    // Row 3
    const Color(0xFFD96FE8), const Color(0xFFF06FA8), const Color(0xFFF07C7C), const Color(0xFF9AA5B1), 
    const Color(0xFF9E9E9E), const Color(0xFFA0A0A0), const Color(0xFFA8A29A),
  ];

  final List<String> _allCategories = [
    'Art', 'Finances', 'Fitness', 'Health', 'Nutrition', 'Social', 'Study', 'Work', 'Other', 'Morning', 'Day', 'Evening'
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(() {
      setState(() {}); // Rebuild to update Save button state
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _showStreakGoalPicker() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => StreakGoalScreen(initialGoal: _streakGoal)),
    );
    if (result != null && mounted) {
      setState(() => _streakGoal = result);
    }
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
                      onCreateNew: () {},
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9747FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  void _pickIcon() async {
    final result = await showIconPicker(context, currentSelection: _iconId);
    if (result != null && mounted) {
      setState(() {
        _iconId = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormValid = _nameCtrl.text.trim().isNotEmpty;
    
    return GlassScaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: GlassAppBar(
        backgroundColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'New Habit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  // Icon / Emoji selector (Top)
                  _buildIconSelector(),
                  
                  const SizedBox(height: 12),
                  
                  // Name Field
                  const Text('Name', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Description Field
                  const Text('Description', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _descCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                      minLines: 1,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Color Picker
                  const Text('Color', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  _buildCustomColorPicker(),
                  const SizedBox(height: 16),
                  
                  // Advanced Options Toggle
                  GestureDetector(
                    onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white12)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Text('Advanced Options', style: TextStyle(color: Colors.white54, fontSize: 13)),
                              const SizedBox(width: 4),
                              Icon(_showAdvanced ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white54, size: 14),
                            ],
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.white12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
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
                                  const Text('Streak Goal', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11)),
                                  const SizedBox(height: 4),
                                  _buildDarkRowOption(_streakGoal, onTap: _showStreakGoalPicker),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Reminder', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11)),
                                  const SizedBox(height: 4),
                                  _buildDarkRowOption(_reminder ?? '0 Active Reminders', onTap: () async {
                                    final result = await Navigator.push<String>(
                                      context,
                                      MaterialPageRoute(builder: (context) => ReminderScreen(initialReminder: _reminder)),
                                    );
                                    if (result != null && mounted) {
                                      setState(() => _reminder = result);
                                    }
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        const Text('Categories', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11)),
                        const SizedBox(height: 4),
                        _buildDarkRowOption(_categories.isEmpty ? 'None' : _categories.join(', '), onTap: _showCategoryPicker),
                        const SizedBox(height: 12),
                        
                        const Text('How should completions be tracked?', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11)),
                        const SizedBox(height: 4),
                        TrackingSegmentedControl(
                          isQuantitative: _isQuantitative,
                          onChanged: (val) => setState(() => _isQuantitative = val),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text('Increment by 1 with each completion', style: TextStyle(color: Colors.white38, fontSize: 11)),
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Completions Per Day', style: TextStyle(color: Color(0xFF9A9A9E), fontSize: 11)),
                            Row(
                              children: [
                                Container(width: 12, height: 12, decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(2))),
                                const SizedBox(width: 4),
                                Container(width: 12, height: 12, decoration: BoxDecoration(color: _color, borderRadius: BorderRadius.circular(2))),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C1C1E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('$_targetValue / Day', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _buildDarkActionButton(Icons.remove, () {
                              if (_targetValue > 1) setState(() => _targetValue--);
                            }),
                            const SizedBox(width: 8),
                            _buildDarkActionButton(Icons.add, () {
                              setState(() => _targetValue++);
                            }),
                            const SizedBox(width: 8),
                            _buildDarkActionButton(Icons.edit_outlined, () {}),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text('The square will be filled completely when this number is met', style: TextStyle(color: Colors.white38, fontSize: 11)),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                    crossFadeState: _showAdvanced ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
            
            // Pinned Save Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid ? const Color(0xFF262628) : const Color(0xFF161616), // Lighten when valid
                    foregroundColor: isFormValid ? Colors.white : Colors.white38,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: isFormValid ? _save : null,
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    // Generate a fixed grid of ~40 decorative icons
    final decorativeIcons = allHabitIcons.values.take(40).toList();

    return Center(
      child: SizedBox(
        height: 100,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background faint grid
            Opacity(
              opacity: 0.08,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                itemCount: decorativeIcons.length,
                itemBuilder: (context, index) {
                  return Icon(decorativeIcons[index], color: Colors.white, size: 24);
                },
              ),
            ),
            // Foreground Circle
            GestureDetector(
              onTap: _pickIcon,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFF1C1C1E),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    getHabitIcon(_iconId),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomColorPicker() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _colors.map((color) {
        final isSelected = color == _color;
        return GestureDetector(
          onTap: () => setState(() => _color = color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? const Center(
                    child: Icon(Icons.circle, color: Colors.black54, size: 12),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDarkRowOption(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white54, size: 20),
      ),
    );
  }

  void _save() async {
    final hexColor = '#${_color.toARGB32().toRadixString(16).substring(2, 8).toUpperCase()}';
    await ref.read(habitNotifierProvider.notifier).addHabit(
          name: _nameCtrl.text.trim(),
          icon: _iconId,
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