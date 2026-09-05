import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/presentation/providers/workout_providers.dart';
import 'package:drift/drift.dart' as drift;

class AddSetBottomSheet extends ConsumerStatefulWidget {
  final String exerciseId;
  const AddSetBottomSheet({super.key, required this.exerciseId});

  static void show(BuildContext context, String exerciseId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddSetBottomSheet(exerciseId: exerciseId),
    );
  }

  @override
  ConsumerState<AddSetBottomSheet> createState() => _AddSetBottomSheetState();
}

class _AddSetBottomSheetState extends ConsumerState<AddSetBottomSheet> {
  String _repsStr = '12';
  String _weightStr = '35';
  bool _isRepsFocused = false; // Default focus to weight
  final _noteController = TextEditingController();

  bool _showPlates = false;
  final Map<double, int> _plateCounts = {2.5: 0, 5.0: 0, 10.0: 0, 25.0: 0, 45.0: 0};
  String _selectedLabel = 'None';
  final Map<String, Color> _labelColors = {
    'Warm-Up': Colors.orange,
    'AMRAP': AppColors.semanticPositive,
    'PR': Colors.amber,
    'Failure': AppColors.semanticUrgent,
    'None': Colors.grey,
  };

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveSet() async {
    final dao = ref.read(workoutDaoProvider);
    final weight = double.tryParse(_weightStr) ?? 0;
    final reps = int.tryParse(_repsStr) ?? 0;

    try {
      await dao.insertSetEntry(SetEntriesCompanion.insert(
        exerciseId: widget.exerciseId,
        weightKg: weight,
        reps: reps,
        note: drift.Value(_noteController.text.trim()),
      ));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save set: $e'), backgroundColor: AppColors.semanticUrgent),
        );
      }
    }
  }

  void _onNumpadPress(String val) {
    setState(() {
      String current = _isRepsFocused ? _repsStr : _weightStr;

      if (val == 'delete') {
        if (current.isNotEmpty) {
          current = current.substring(0, current.length - 1);
          if (current.isEmpty) current = '0';
        }
      } else if (val == '.') {
        if (!_isRepsFocused && !current.contains('.')) {
          current += '.';
        }
      } else {
        if (current == '0') {
          current = val;
        } else {
          current += val;
        }
      }

      if (_isRepsFocused) {
        _repsStr = current;
      } else {
        _weightStr = current;
      }
    });
  }

  void _adjustValue(bool isReps, double amount) {
    setState(() {
      if (isReps) {
        double val = double.tryParse(_repsStr) ?? 0;
        val += amount;
        if (val < 0) val = 0;
        _repsStr = val.toInt().toString();
      } else {
        double val = double.tryParse(_weightStr) ?? 0;
        val += amount;
        if (val < 0) val = 0;
        _weightStr = val.toString().replaceAll(RegExp(r'\.0$'), '');
      }
    });
  }

  void _showLabelPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedHigh.withValues(alpha: 0.95), // Glassy feel
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Text('Labels', style: TextStyle(color: AppColors.textTertiary, fontSize: 16.sp, fontWeight: FontWeight.w600)),
              ),
              ..._labelColors.entries.map((e) {
                 bool isSelected = _selectedLabel == e.key;
                 return InkWell(
                   onTap: () {
                     setState(() => _selectedLabel = e.key);
                     Navigator.pop(context);
                   },
                   child: Column(
                     children: [
                       Padding(
                         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                         child: Row(
                           children: [
                             CircleAvatar(radius: 6.r, backgroundColor: e.value),
                             SizedBox(width: 16.w),
                             Expanded(child: Text(e.key, style: TextStyle(color: AppColors.textPrimary, fontSize: 16.sp, fontWeight: FontWeight.w500))),
                             if (isSelected) Icon(LucideIcons.check, color: AppColors.textSecondary, size: 20.sp),
                           ],
                         ),
                       ),
                       if (e.key != 'None') Divider(color: AppColors.borderSpecular, height: 1, indent: 44.w, endIndent: 20.w),
                     ],
                   ),
                 );
              }),
              SizedBox(height: 8.h),
            ],
          ),
        );
      }
    );
  }

  Widget _buildPlatesView() {
    return Container(
      color: GymTheme.cardBackground,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [2.5, 5.0, 10.0, 25.0, 45.0].map((plate) {
          int count = _plateCounts[plate]!;
          return _buildPlateColumn(plate, count);
        }).toList(),
      ),
    );
  }

  Widget _buildPlateColumn(double plate, int count) {
    return Container(
      width: 60.w,
      height: 160.h,
      decoration: BoxDecoration(
        color: const Color(0xFF505050),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
               setState(() {
                 _plateCounts[plate] = _plateCounts[plate]! + 1;
                 double w = double.tryParse(_weightStr) ?? 0;
                 w += plate * 2; // Adding 2 plates (one per side)
                 _weightStr = w.toString().replaceAll(RegExp(r'\.0$'), '');
               });
            },
            child: count > 0 
                ? CircleAvatar(radius: 14.r, backgroundColor: AppColors.surfacePitchBlack, child: Text(count.toString(), style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp, fontWeight: FontWeight.bold)))
                : Icon(LucideIcons.plus, color: AppColors.textSecondary, size: 20.sp),
          ),
          Text(plate == plate.toInt() ? plate.toInt().toString() : plate.toString(), style: TextStyle(color: AppColors.textPrimary, fontSize: 20.sp, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () {
               if (count > 0) {
                 setState(() {
                   _plateCounts[plate] = _plateCounts[plate]! - 1;
                   double w = double.tryParse(_weightStr) ?? 0;
                   w -= plate * 2; 
                   if (w < 0) w = 0;
                   _weightStr = w.toString().replaceAll(RegExp(r'\.0$'), '');
                 });
               }
            },
            child: Icon(LucideIcons.minus, color: AppColors.textSecondary, size: 20.sp),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedHigh,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──
          Container(
            margin: EdgeInsets.only(top: 8.h, bottom: 12.h),
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.borderSpecular,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // ── Main Input Row: 12 rep  – +  |35| kg  –1 +1 / –5 +5 ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Reps display (tappable)
                GestureDetector(
                  onTap: () => setState(() => _isRepsFocused = true),
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _repsStr.isEmpty ? '0' : _repsStr,
                          style: TextStyle(
                            color: GymTheme.textPrimary,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'rep',
                          style: TextStyle(
                            color: GymTheme.textSecondary,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Reps – / + stepper buttons
                _buildCircleButton(LucideIcons.minus, () => _adjustValue(true, -1)),
                SizedBox(width: 6.w),
                _buildCircleButton(LucideIcons.plus, () => _adjustValue(true, 1)),

                SizedBox(width: 12.w),

                // Weight display with orange cursor (tappable)
                GestureDetector(
                  onTap: () => setState(() => _isRepsFocused = false),
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Weight value box with border
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: !_isRepsFocused
                              ? BoxDecoration(
                                  border: Border.all(color: GymTheme.weightAccent, width: 1.5),
                                  borderRadius: BorderRadius.circular(4.r),
                                )
                              : null,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                _weightStr.isEmpty ? '0' : _weightStr,
                                style: TextStyle(
                                  color: GymTheme.textPrimary,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'kg',
                                style: TextStyle(
                                  color: GymTheme.textSecondary,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Orange dots (top + bottom) when weight is focused
                        if (!_isRepsFocused) ...[
                          Positioned(
                            top: -4.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: GymTheme.weightAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -4.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: GymTheme.weightAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Quick increment buttons (right side)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildQuickButton('–', '1', () => _adjustValue(_isRepsFocused, -1)),
                        SizedBox(width: 4.w),
                        _buildQuickButton('+', '1', () => _adjustValue(_isRepsFocused, 1)),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildQuickButton('–', '5', () => _adjustValue(_isRepsFocused, -5)),
                        SizedBox(width: 4.w),
                        _buildQuickButton('+', '5', () => _adjustValue(_isRepsFocused, 5)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // ── Action Chips Row ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                _buildChip(
                  LucideIcons.sparkles, 
                  _selectedLabel == 'None' ? 'Label' : _selectedLabel, 
                  _selectedLabel == 'None' ? const Color(0xFFFF9F0A) : _labelColors[_selectedLabel],
                  useColorDot: _selectedLabel != 'None',
                  onTap: () => _showLabelPopup(context),
                ),
                SizedBox(width: 6.w),
                _buildChip(LucideIcons.disc, 'Plates', const Color(0xFFFF9F0A), onTap: () {
                  setState(() => _showPlates = true);
                }),
                SizedBox(width: 6.w),
                _buildChip(LucideIcons.dumbbell, 'Weight', null),
                SizedBox(width: 6.w),
                _buildChip(LucideIcons.lock, 'KG', null),
                SizedBox(width: 6.w),
                _buildChip(LucideIcons.calendar, 'Now', null),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // ── Add Note + Green Save Button ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _noteController,
                    style: TextStyle(color: GymTheme.textPrimary, fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'Add note',
                      hintStyle: TextStyle(color: GymTheme.textSecondary, fontSize: 14.sp),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: _saveSet,
                  child: Container(
                    width: 140.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759),
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(LucideIcons.check, color: AppColors.textPrimary, size: 24.sp),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // ── Conditional Numpad / Plates View ──
          if (_showPlates)
            _buildPlatesView()
          else
            Container(
              color: GymTheme.cardBackground,
              padding: EdgeInsets.only(
                top: 8.h,
                left: 4.w,
                right: 4.w,
              ),
              child: Column(
                children: [
                  _buildNumpadRow(['1', '2', '3']),
                  SizedBox(height: 6.h),
                  _buildNumpadRow(['4', '5', '6']),
                  SizedBox(height: 6.h),
                  _buildNumpadRow(['7', '8', '9']),
                  SizedBox(height: 6.h),
                  _buildNumpadRow(['.', '0', 'delete']),
                ],
              ),
            ),

          // ── Bottom bar: keyboard + share icons ──
          Container(
            color: GymTheme.cardBackground,
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 8.h,
              bottom: bottomPadding + 8.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_showPlates) {
                      setState(() => _showPlates = false);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(LucideIcons.keyboard, color: AppColors.textTertiary, size: 22.sp),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(LucideIcons.share2, color: AppColors.textTertiary, size: 22.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Circle stepper button (– / +) ──
  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26.w,
        height: 26.w,
        decoration: const BoxDecoration(
          color: Color(0xFF3A3A3C),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.textSecondary, size: 14.sp),
      ),
    );
  }

  // ── Quick increment pill: "– 1", "+ 5", etc. ──
  Widget _buildQuickButton(String sign, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 26.h,
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3C),
          borderRadius: BorderRadius.circular(4.r),
        ),
        alignment: Alignment.center,
        child: Text(
          '$sign $value',
          style: TextStyle(
            color: AppColors.textTertiary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ── Action chip (Label, Plates, Weight, KG, Now) ──
  Widget _buildChip(IconData icon, String label, Color? iconColor, {bool useColorDot = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3C),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (useColorDot && iconColor != null)
              // Custom dot for Label instead of icon if selected
              CircleAvatar(radius: 5.r, backgroundColor: iconColor)
            else
              Icon(icon, color: iconColor ?? AppColors.textTertiary, size: 14.sp),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Numpad row ──
  Widget _buildNumpadRow(List<String> keys) {
    return Row(
      children: keys.map((k) {
        if (k == 'delete') {
          return Expanded(
            child: _buildNumpadKey(k, icon: LucideIcons.delete),
          );
        } else if (k == '.') {
          return Expanded(
            child: _buildNumpadKey(k),
          );
        }
        return Expanded(
          child: _buildNumpadKey(k),
        );
      }).toList(),
    );
  }

  // ── Single numpad key ──
  Widget _buildNumpadKey(String value, {IconData? icon}) {
    return GestureDetector(
      onTap: () => _onNumpadPress(value),
      child: Container(
        height: 46.h,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: const Color(0xFF505050),
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, color: AppColors.textPrimary, size: 20.sp)
            : Text(
                value,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
