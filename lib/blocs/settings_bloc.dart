import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/models/user_settings.dart';
import 'package:weight_tracker/repositories/settings_repository.dart';
import 'package:weight_tracker/services/notification_service.dart';

class SettingsBloc extends Cubit<UserSettings> {
  final SettingsRepository _repository;

  SettingsBloc(this._repository) : super(UserSettings()) {
    loadSettings();
  }

  void loadSettings() async {
    final settings = await _repository.getSettings();
    emit(settings);
  }

  void updateSettings(UserSettings settings) async {
    await _repository.saveSettings(settings);
    await NotificationService().scheduleNotification(settings.notificationTime);
    emit(settings);
  }
}
