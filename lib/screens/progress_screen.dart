import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/blocs/weight_bloc.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedPeriod = '1M'; // Default to 1 month

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Analysis'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<WeightBloc, List<WeightEntry>>(
        builder: (context, weights) {
          if (weights.isEmpty) {
            return Center(child: Text('No weight entries yet.'));
          }

          List<WeightEntry> filteredWeights = _filterWeights(weights);
          double totalWeightLoss = _calculateTotalWeightLoss(filteredWeights);
          double averageWeightLoss = _calculateAverageWeightLoss(filteredWeights);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPeriodSelector(),
                SizedBox(height: 16),
                _buildProgressSummary(totalWeightLoss, averageWeightLoss),
                SizedBox(height: 24),
                Text('Weight Trend', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                Container(
                  height: 300,
                  child: WeightChart(weights: filteredWeights),
                ),
                SizedBox(height: 24),
                Text('Insights', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                _buildInsights(filteredWeights),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['1W', '1M', '3M', '6M', '1Y', 'All'].map((String period) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: ChoiceChip(
              label: Text(period),
              selected: _selectedPeriod == period,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgressSummary(double totalWeightLoss, double averageWeightLoss) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress Summary', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8,
            width: double.infinity,),
            Text('Total Weight Loss: ${totalWeightLoss.toStringAsFixed(1)} kg'),
            Text('Average Weight Loss: ${averageWeightLoss.toStringAsFixed(2)} kg/week'),
          ],
        ),
      ),
    );
  }

  Widget _buildInsights(List<WeightEntry> weights) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You\'ve made progress!', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('Keep up the good work and stay consistent with your habits.'),
          ],
        ),
      ),
    );
  }

  List<WeightEntry> _filterWeights(List<WeightEntry> weights) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case '1W':
        startDate = now.subtract(Duration(days: 7));
        break;
      case '1M':
        startDate = now.subtract(Duration(days: 30));
        break;
      case '3M':
        startDate = now.subtract(Duration(days: 90));
        break;
      case '6M':
        startDate = now.subtract(Duration(days: 180));
        break;
      case '1Y':
        startDate = now.subtract(Duration(days: 365));
        break;
      case 'All':
      default:
        return weights;
    }

    return weights.where((entry) => entry.date.isAfter(startDate)).toList();
  }

  double _calculateTotalWeightLoss(List<WeightEntry> weights) {
    if (weights.length < 2) return 0;
    return weights.first.weight - weights.last.weight;
  }

  double _calculateAverageWeightLoss(List<WeightEntry> weights) {
    if (weights.length < 2) return 0;
    double totalLoss = _calculateTotalWeightLoss(weights);
    int weeks = weights.first.date.difference(weights.last.date).inDays ~/ 7;
    return weeks > 0 ? totalLoss / weeks : 0;
  }
}

class WeightChart extends StatelessWidget {
  final List<WeightEntry> weights;

  WeightChart({required this.weights});

  @override
  Widget build(BuildContext context) {
    if (weights.isEmpty) {
      return Center(child: Text('No data available'));
    }

    double minY = weights.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    double maxY = weights.map((e) => e.weight).reduce((a, b) => a > b ? a : b);
    double yRange = maxY - minY;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index % ((weights.length / 5).ceil()) == 0 && index < weights.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat.MMMd().format(weights[index].date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()} kg',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                );
              },
              reservedSize: 40,
              interval: yRange / 5,
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: weights.length.toDouble() - 1,
        minY: minY - (yRange * 0.1),
        maxY: maxY + (yRange * 0.1),
        lineBarsData: [
          LineChartBarData(
            spots: weights.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.weight);
            }).toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.secondary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
