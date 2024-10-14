import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/blocs/weight_bloc.dart';
import 'package:weight_tracker/blocs/settings_bloc.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/models/user_settings.dart';
import 'package:weight_tracker/screens/add_weight_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, UserSettings>(
      builder: (context, settings) {
        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
             flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromARGB(255, 77, 166, 136),
                          Color.fromARGB(255, 65, 112, 106)
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment
                            .bottomLeft, 
                        child: Padding(
                          padding: const EdgeInsets.only(top: 24, left: 16),
                          child: Text(
                            _getGreeting(settings.userName),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors
                                  .white, // 
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HealthOverviewCard(),
                      SizedBox(height: 16),
                      // WeightChartCard(),
                      SizedBox(height: 16),
                      RecentWeightEntriesCard(),
                    ],
                  ),
                ),
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
      },
    );
  }

  String _getGreeting(String name) {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning,\n$name';
    } else if (hour < 17) {
      return 'Good afternoon,\n$name';
    } else {
      return 'Good evening,\n$name';
    }
  }
}

class HealthOverviewCard extends StatefulWidget {
  @override
  _HealthOverviewCardState createState() => _HealthOverviewCardState();
}

class _HealthOverviewCardState extends State<HealthOverviewCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, List<WeightEntry>>(
      builder: (context, weights) {
        double currentWeight = weights.isNotEmpty ? weights.first.weight : 0;
        double weightLoss = _calculateWeightLoss(weights);
        int daysTracked = weights.length;

        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Health Overview', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMetric(context, Icons.monitor_weight, currentWeight.toStringAsFixed(1), 'Current Weight'),
                    _buildMetric(context, Icons.trending_down, weightLoss.toStringAsFixed(1), 'Weight Loss'),
                    _buildMetric(context, Icons.calendar_today, daysTracked.toString(), 'Days Tracked'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetric(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.secondary),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  double _calculateWeightLoss(List<WeightEntry> weights) {
    if (weights.length < 2) return 0;
    return weights.first.weight - weights.last.weight;
  }
}

class RecentWeightEntriesCard extends StatefulWidget {
  @override
  _RecentWeightEntriesCardState createState() => _RecentWeightEntriesCardState();
}

class _RecentWeightEntriesCardState extends State<RecentWeightEntriesCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeightBloc, List<WeightEntry>>(
      builder: (context, weights) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Entries', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 16),
                Column(
                  children: weights.take(5).map((entry) => _buildWeightListItem(context, entry)).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeightListItem(BuildContext context, WeightEntry entry) {
    return Dismissible(
      key: Key(entry.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<WeightBloc>().deleteWeight(entry);
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            '${entry.weight.toStringAsFixed(1)}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        title: Text(
          '${entry.weight} kg',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          DateFormat('MMM d, y').format(entry.date),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Theme.of(context).iconTheme.color),
      ),
    );
  }
}
