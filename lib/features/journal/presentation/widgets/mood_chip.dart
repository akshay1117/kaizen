import 'package:flutter/material.dart';
import '../../domain/models/journal_entry.dart';

class MoodChip extends StatelessWidget {
  final Mood mood;
  const MoodChip({super.key, required this.mood});

  Color _getMoodColor() {
    switch (mood) {
      case Mood.happy:
        return Colors.amber.withOpacity(0.2);
      case Mood.calm:
        return Colors.blue.withOpacity(0.2);
      case Mood.excited:
        return Colors.purple.withOpacity(0.2);
      case Mood.sad:
        return Colors.indigo.withOpacity(0.2);
      case Mood.angry:
        return Colors.red.withOpacity(0.2);
    }
  }

  Color _getTextColor() {
    switch (mood) {
      case Mood.happy:
        return Colors.amber;
      case Mood.calm:
        return Colors.blue;
      case Mood.excited:
        return Colors.purpleAccent;
      case Mood.sad:
        return Colors.indigoAccent;
      case Mood.angry:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getMoodColor(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getTextColor().withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(mood.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            mood.displayName,
            style: TextStyle(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
