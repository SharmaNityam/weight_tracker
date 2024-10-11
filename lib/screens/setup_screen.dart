import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/blocs/settings_bloc.dart';
import 'package:weight_tracker/models/user_settings.dart';
import 'package:weight_tracker/screens/home_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _nameController = TextEditingController();
  TimeOfDay _notificationTime = TimeOfDay(hour: 9, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Weight Tracker')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notification Time: ${_notificationTime.format(context)}'),
                ElevatedButton(
                  child: Text('Set Time'),
                  onPressed: _selectTime,
                ),
              ],
            ),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Start Tracking'),
              onPressed: _finishSetup,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
    }
  }

  void _finishSetup() async {
    if (_nameController.text.isNotEmpty) {
      final settings = UserSettings(
        userName: _nameController.text,
        notificationTime: _notificationTime,
      );
      context.read<SettingsBloc>().updateSettings(settings);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstRun', false);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your name')),
      );
    }
  }
}