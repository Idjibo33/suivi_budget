import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:suivi_budget/constants.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(drawBelowEverything: false),
          topTitles: AxisTitles(drawBelowEverything: false),
        ),
        barGroups: data,
      ),
    );
  }
}

final List<BarChartGroupData> data = [
  BarChartGroupData(
    x: 1,
    barRods: [BarChartRodData(toY: 80, color: couleurDepense)],
  ),
  BarChartGroupData(
    x: 2,
    barRods: [BarChartRodData(toY: 10, color: couleurRevenu)],
  ),
  BarChartGroupData(
    x: 3,
    barRods: [BarChartRodData(toY: 50, color: couleurDepense)],
  ),
  BarChartGroupData(
    x: 5,
    barRods: [BarChartRodData(toY: 10, color: couleurRevenu)],
  ),
  BarChartGroupData(
    x: 5,
    barRods: [BarChartRodData(toY: 30, color: couleurRevenu)],
  ),
  BarChartGroupData(
    x: 6,
    barRods: [BarChartRodData(toY: 90, color: couleurDepense)],
  ),
  BarChartGroupData(
    x: 7,
    barRods: [BarChartRodData(toY: 100, color: couleurRevenu)],
  ),
];
