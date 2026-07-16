import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:optimos/controller/habit_providers.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  String _icon = '🏋️';
  String _color = '#5FD068';
  String _frequency = 'daily';
  String? _reminder;
  bool _isQuantitative = false;
  final _targetCtrl = TextEditingController(text: '1');
  final _unitCtrl = TextEditingController();

  final List<String> _icons = ['🏋️', '🏃', '📖', '💊', '💧', '🧘', '🥗', '💤'];
  final List<String> _colors = ['#5FD068', '#00C9B1', '#FF4D4D', '#FF8C00', '#FFD700', '#B57BFF'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Habit name'), validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Icon: '),
              DropdownButton(value: _icon, items: _icons.map((ic) => DropdownMenuItem(value: ic, child: Text(ic))).toList(), onChanged: (v) => setState(() => _icon = v!)),
              const Spacer(),
              const Text('Color: '),
              DropdownButton(value: _color, items: _colors.map((c) => DropdownMenuItem(value: c, child: Container(width: 20, height: 20, color: Color(int.parse(c.replaceFirst('#', '0xFF')))))).toList(), onChanged: (v) => setState(() => _color = v!)),
            ]),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              value: _frequency,
              items: const [DropdownMenuItem(value: 'daily', child: Text('Daily')), DropdownMenuItem(value: 'weekly', child: Text('Weekly'))],
              onChanged: (v) => setState(() => _frequency = v!),
              decoration: const InputDecoration(labelText: 'Frequency'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Reminder (optional)'),
              trailing: Switch(value: _reminder != null, onChanged: (b) => setState(() => _reminder = b ? '09:00' : null)),
            ),
            if (_reminder != null)
              ListTile(
                title: const Text('Reminder time'),
                subtitle: Text(_reminder!),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () async {
                    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (picked != null) {
                      setState(() => _reminder = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
                    }
                  },
                ),
              ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Goal based habit (e.g. 5 glasses)'),
          value: _isQuantitative,
          onChanged: (b) => setState(() => _isQuantitative = b),
        ),
        if (_isQuantitative) ...[
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _targetCtrl,
                  decoration: const InputDecoration(labelText: 'Target value'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _unitCtrl,
                  decoration: const InputDecoration(labelText: 'Unit (e.g. pages)'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ),
            ]
          )
        ],
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Create Habit')),
          ],
        ),
      ),
    );
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(habitNotifierProvider.notifier).addHabit(
            name: _nameCtrl.text,
            icon: _icon,
            color: _color,
            frequency: _frequency,
            reminderTime: _reminder,
            isQuantitative: _isQuantitative,
            targetValue: int.tryParse(_targetCtrl.text) ?? 1,
            unit: _unitCtrl.text.isEmpty ? null : _unitCtrl.text,
          );
      if (mounted) {
        context.pop();
      }
    }
  }
}