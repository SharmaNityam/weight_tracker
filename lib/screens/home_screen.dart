import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/blocs/weight_bloc.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/screens/add_weight_screen.dart';
import 'package:weight_tracker/screens/settings_screen.dart';
import 'package:weight_tracker/widgets/weight_list_item.dart';
import 'package:weight_tracker/widgets/weight_chart.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Weight Tracker'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.teal, Colors.tealAccent],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsScreen()),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              padding: EdgeInsets.all(16),
              child: BlocBuilder<WeightBloc, List<WeightEntry>>(
                builder: (context, weights) {
                  return WeightChart(weights: weights);
                },
              ),
            ),
          ),
          BlocBuilder<WeightBloc, List<WeightEntry>>(
            builder: (context, weights) {
              if (weights.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text('No weight entries yet.')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final entry = weights[index];
                    final previousDay = index < weights.length - 1
                        ? weights[index + 1].date
                        : entry.date.subtract(Duration(days: 1));
                    
                    final List<Widget> items = [];
                    
                    // Add missed days
                    for (int i = 1; i < entry.date.difference(previousDay).inDays; i++) {
                      items.add(ListTile(
                        title: Text('No entry'),
                        subtitle: Text(previousDay.add(Duration(days: i)).toString().split(' ')[0]),
                        tileColor: Colors.grey[200],
                      ));
                    }
                    
                    // Add the actual weight entry
                    items.add(WeightListItem(
                      entry: entry,
                      onDelete: () => _showDeleteConfirmation(context, entry),
                    ));
                    
                    return Column(children: items);
                  },
                  childCount: weights.length,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddWeightScreen()),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WeightEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Entry'),
          content: Text('Are you sure you want to delete this weight entry?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                context.read<WeightBloc>().deleteWeight(entry);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}