import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:weight_tracker/models/weight_entry.dart';

class WeightChart extends StatelessWidget {
  final List<WeightEntry> weights;

  const WeightChart({Key? key, required this.weights}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()} kg',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: weights.length.toDouble() - 1,
        minY: weights.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 1,
        maxY: weights.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 1,
        lineBarsData: [
          LineChartBarData(
            spots: weights.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.weight);
            }).toList(),
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}