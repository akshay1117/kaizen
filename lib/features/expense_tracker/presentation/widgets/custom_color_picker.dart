import 'package:flutter/material.dart';

class CustomColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const CustomColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  int _selectedTab = 0; // 0: Grid, 1: Spectrum, 2: Sliders
  late Color _currentColor;

  final List<Color> _gridColors = [
    const Color(0xFFFFFFFF), const Color(0xFFE5E5EA), const Color(0xFFD1D1D6), const Color(0xFFC7C7CC), const Color(0xFFAEAEB2), const Color(0xFF8E8E93),
    const Color(0xFFFF3B30), const Color(0xFFFF9500), const Color(0xFFFFCC00), const Color(0xFF34C759), const Color(0xFF5AC8FA), const Color(0xFF007AFF),
    const Color(0xFF5856D6), const Color(0xFFAF52DE), const Color(0xFFFF2D55), const Color(0xFF000000), const Color(0xFF1C1C1E), const Color(0xFF2C2C2E),
  ];

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  void _updateColor(Color color) {
    setState(() {
      _currentColor = color;
    });
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tabs
        Container(
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildTab(0, 'Grid'),
              _buildTab(1, 'Spectrum'),
              _buildTab(2, 'Sliders'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Tab Content
        SizedBox(
          height: 200,
          child: _selectedTab == 0
              ? _buildGrid()
              : _selectedTab == 1
                  ? _buildSpectrum()
                  : _buildSliders(),
        ),
      ],
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF3A3A3C) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          margin: const EdgeInsets.all(2),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF8E8E93),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _gridColors.length,
      itemBuilder: (context, index) {
        final color = _gridColors[index];
        final isSelected = _currentColor == color;
        return GestureDetector(
          onTap: () => _updateColor(color),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFF0A84FF) : Colors.transparent,
                width: 3,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpectrum() {
    // A mock spectrum for the UI. (Real spectrum would require a custom painter and gesture detector)
    return GestureDetector(
      onTapDown: (details) {
        // Mocking color picking from spectrum based on position
        _updateColor(Colors.tealAccent);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Colors.red, Colors.yellow, Colors.green, Colors.cyan, Colors.blue, Colors.purple, Colors.red],
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 3),
            color: _currentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSliders() {
    return Column(
      children: [
        _buildSliderRow('RED', _currentColor.r.toDouble() * 255, Colors.red, (v) {
          _updateColor(Color.fromRGBO(v.toInt(), (_currentColor.g * 255).toInt(), (_currentColor.b * 255).toInt(), 1));
        }),
        _buildSliderRow('GREEN', _currentColor.g.toDouble() * 255, Colors.green, (v) {
          _updateColor(Color.fromRGBO((_currentColor.r * 255).toInt(), v.toInt(), (_currentColor.b * 255).toInt(), 1));
        }),
        _buildSliderRow('BLUE', _currentColor.b.toDouble() * 255, Colors.blue, (v) {
          _updateColor(Color.fromRGBO((_currentColor.r * 255).toInt(), (_currentColor.g * 255).toInt(), v.toInt(), 1));
        }),
        const SizedBox(height: 16),
        Text(
          'sRGB Hex Color # ${_currentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
          style: const TextStyle(color: Color(0xFF0A84FF), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSliderRow(String label, double value, Color activeColor, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(label, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12)),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: activeColor,
              inactiveTrackColor: const Color(0xFF3A3A3C),
              thumbColor: Colors.white,
              trackHeight: 12,
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 255,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            value.toInt().toString(),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
