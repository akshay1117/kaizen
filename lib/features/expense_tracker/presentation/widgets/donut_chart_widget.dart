import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DonutChartWidget extends StatelessWidget {
  const DonutChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 90,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  color: const Color(0xFF0A84FF), // Blue
                  value: 40,
                  title: '',
                  radius: 12,
                ),
                PieChartSectionData(
                  color: const Color(0xFFFF3B30), // Red
                  value: 30,
                  title: '',
                  radius: 12,
                ),
                PieChartSectionData(
                  color: const Color(0xFFFF9500), // Orange
                  value: 15,
                  title: '',
                  radius: 12,
                ),
                PieChartSectionData(
                  color: const Color(0xFF34C759), // Green
                  value: 15,
                  title: '',
                  radius: 12,
                ),
              ],
            ),
          ),
          // Inner content
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Last 365 days',
                style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
              ),
              SizedBox(height: 4),
              Text(
                'Total:',
                style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
              ),
              Text(
                '₹2,340.50',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ø per day: ₹6.41',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 10),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Ø per person: ₹2,340.50',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
