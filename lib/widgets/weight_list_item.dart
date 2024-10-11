import 'package:flutter/material.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/utils/date_utils.dart';

class WeightListItem extends StatelessWidget {
  final WeightEntry entry;
  final VoidCallback onDelete;

  const WeightListItem({Key? key, required this.entry, required this.onDelete}) : super(key: key);

   @override
  Widget build(BuildContext context) {
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
        onDelete();
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              '${entry.weight.toStringAsFixed(1)}',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            '${entry.weight} kg',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(AppDateUtils.formatDate(entry.date)),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}