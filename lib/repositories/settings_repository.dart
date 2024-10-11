import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_tracker/models/user_settings.dart';

class SettingsRepository {
  Future<UserSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return UserSettings.fromMap({
      'userName': prefs.getString('userName') ?? '',
      'notificationTime': prefs.getString('notificationTime') ?? '9:00',
    });
  }

  Future<void> saveSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', settings.userName);
    await prefs.setString('notificationTime', '${settings.notificationTime.hour}:${settings.notificationTime.minute}');
  }
}