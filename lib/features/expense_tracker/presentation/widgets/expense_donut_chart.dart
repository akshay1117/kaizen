import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';



class ExpenseDonutChart extends StatelessWidget {
  final String periodText;
  final String totalAmount;
  final String averagePerDay;
  final String averagePerPerson;
  final List<PieChartSectionData> sections;

  const ExpenseDonutChart({
    super.key,
    required this.periodText,
    required this.totalAmount,
    required this.averagePerDay,
    required this.averagePerPerson,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 110,
              sections: sections,
              startDegreeOffset: 270,
            ),
            duration: const Duration(milliseconds: 150),
            curve: Curves.linear,
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                periodText,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Total:',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                totalAmount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAverageItem('Ø per day', averagePerDay),
                  const SizedBox(width: 16),
                  _buildAverageItem('Ø per person', averagePerPerson),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAverageItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8E8E93),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}


