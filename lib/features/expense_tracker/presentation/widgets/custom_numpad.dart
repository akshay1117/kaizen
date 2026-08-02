import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNumpad extends StatelessWidget {
  final Function(String) onNumberTapped;
  final VoidCallback onBackspaceTapped;
  final VoidCallback onDotTapped;

  const CustomNumpad({
    super.key,
    required this.onNumberTapped,
    required this.onBackspaceTapped,
    required this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF121212),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 8),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 8),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('.', onTap: onDotTapped),
              _buildButton('0', onTap: () => onNumberTapped('0')),
              _buildButton('backspace', onTap: onBackspaceTapped, isIcon: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers
          .map((number) => _buildButton(
                number,
                onTap: () => onNumberTapped(number),
              ))
          .toList(),
    );
  }

  Widget _buildButton(String label, {required VoidCallback onTap, bool isIcon = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: 52,
        alignment: Alignment.center,
        child: isIcon
            ? const Icon(
                Icons.backspace_outlined,
                color: Colors.white,
                size: 28,
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
    );
  }
}
