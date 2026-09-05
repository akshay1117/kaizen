import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class ReminderScreen extends StatefulWidget {
  final String? initialReminder;

  const ReminderScreen({super.key, this.initialReminder});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String? _selectedReminder;

  @override
  void initState() {
    super.initState();
    _selectedReminder = widget.initialReminder;
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: AppColors.surfacePitchBlack, // Dark background matching the screenshot
      appBar: GlassAppBar(
        backgroundColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context, _selectedReminder),
        ),
        title: Text('Reminder (${_selectedReminder != null ? 1 : 0} / 1)', style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.surfacePitchBlack,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Missing permission', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        const Text(
                          'Give HabitKit the permission to send you notifications in order to use this feature.',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            // Request permission logic here
                          },
                          child: const Text('Give permission', style: TextStyle(color: Color(0xFFA855F7), fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            if (_selectedReminder == null)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.alarm, color: AppColors.textPrimary, size: 40),
                    const SizedBox(height: 16),
                    const Text('No Reminders', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text(
                      'Add a reminder to your habit for daily notifications.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentViolet,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                      ),
                      onPressed: _openTimePicker,
                      child: const Text('Add Reminder', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Reminder #1', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfacePitchBlack,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
                              bool isSelected = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].contains(day);
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.accentViolet : AppColors.surfaceObsidian,
                                  borderRadius: BorderRadius.circular(AppRadii.sm),
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: isSelected ? AppColors.textPrimary : AppColors.textTertiary,
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: _openTimePicker,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceObsidian,
                                      borderRadius: BorderRadius.circular(AppRadii.md),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.access_time, color: AppColors.textPrimary, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatTime(_selectedReminder!),
                                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _selectedReminder = null);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceObsidian,
                                    borderRadius: BorderRadius.circular(AppRadii.md),
                                  ),
                                  child: const Icon(Icons.delete_outline, color: AppColors.textPrimary, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.surfacePitchBlack,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
                        ),
                        onPressed: () {
                          // Max 1 reminder for now
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add Reminder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      int h = int.parse(parts[0]);
      int m = int.parse(parts[1]);
      final ampm = h >= 12 ? 'PM' : 'AM';
      if (h == 0) h = 12;
      if (h > 12) h -= 12;
      return '$h:${m.toString().padLeft(2, '0')} $ampm';
    } catch (e) {
      return time24;
    }
  }

  Future<void> _openTimePicker() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.accentViolet,
              surface: AppColors.surfaceElevatedHigh,
              onSurface: AppColors.textPrimary,
              onPrimary: AppColors.textPrimary,
              surfaceContainerHighest: AppColors.surfaceObsidian, // For clock dial background
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surfaceElevatedHigh,
              hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
              dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.sm)),
              dayPeriodBorderSide: const BorderSide(color: AppColors.borderSpecular),
              dialHandColor: AppColors.accentViolet,
              dialBackgroundColor: AppColors.surfaceObsidian,
              entryModeIconColor: AppColors.textSecondary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.accentViolet),
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        final hour = time.hour.toString().padLeft(2, '0');
        final minute = time.minute.toString().padLeft(2, '0');
        _selectedReminder = '$hour:$minute';
      });
    }
  }
}
