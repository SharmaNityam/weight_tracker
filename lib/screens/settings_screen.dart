import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/blocs/settings_bloc.dart';
import 'package:weight_tracker/models/user_settings.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TimeOfDay _notificationTime;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsBloc>().state;
    _nameController = TextEditingController(text: settings.userName);
    _notificationTime = settings.notificationTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, UserSettings>(
        builder: (context, settings) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Your Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Notification Time: ${_notificationTime.format(context)}'),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        child: Text('Change Time'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    child: Text('Save Settings'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
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

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final newSettings = UserSettings(
        userName: _nameController.text,
        notificationTime: _notificationTime,
      );
      context.read<SettingsBloc>().updateSettings(newSettings);
      Navigator.pop(context);
    }
  }
}