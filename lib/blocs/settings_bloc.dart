import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/models/user_settings.dart';
import 'package:weight_tracker/repositories/settings_repository.dart';
import 'package:weight_tracker/services/notification_service.dart';

class SettingsBloc extends Cubit<UserSettings> {
  final SettingsRepository _repository;
  final NotificationService _notificationService;

  SettingsBloc(this._repository, this._notificationService) : super(UserSettings()) {
    loadSettings();
  }

  void loadSettings() async {
    final settings = await _repository.getSettings();
    emit(settings);
  }

  Future<void> updateSettings(UserSettings settings) async {
    await _repository.saveSettings(settings);
    if (settings.notificationTime != null) {
      await _notificationService.scheduleNotification(settings.notificationTime!);
    }
    emit(settings);
  }

  void updateThemeMode(ThemeMode themeMode) {
    final updatedSettings = state.copyWith(themeMode: themeMode);
    updateSettings(updatedSettings);
  }

  void updateUserName(String userName) {
    final updatedSettings = state.copyWith(userName: userName);
    updateSettings(updatedSettings);
  }

  void updateNotificationTime(TimeOfDay? notificationTime) {
    final updatedSettings = state.copyWith(notificationTime: notificationTime);
    updateSettings(updatedSettings);
  }
}
