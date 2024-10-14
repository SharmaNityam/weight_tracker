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
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text('Notification Time'),
                  subtitle: Text(_notificationTime.format(context)),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () => _selectTime(context),
                ),
                SizedBox(height: 16),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text('Save Settings'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
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
      final newSettings = context.read<SettingsBloc>().state.copyWith(
        userName: _nameController.text,
        notificationTime: _notificationTime,
      );
      context.read<SettingsBloc>().updateSettings(newSettings);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Settings saved')),
      );
    }
  }
}
