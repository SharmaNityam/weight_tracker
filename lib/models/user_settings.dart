import 'package:flutter/material.dart';

class UserSettings {
  final String userName;
  final TimeOfDay notificationTime;
  final ThemeMode themeMode;

  UserSettings({
    this.userName = '',
    this.notificationTime = const TimeOfDay(hour: 9, minute: 0),
    this.themeMode = ThemeMode.dark, // Set default to dark
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'notificationTime': '${notificationTime.hour}:${notificationTime.minute}',
      'themeMode': themeMode.index,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    final timeParts = map['notificationTime'].split(':');
    return UserSettings(
      userName: map['userName'],
      notificationTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      themeMode: ThemeMode.values[map['themeMode'] ?? ThemeMode.dark.index],
    );
  }

  UserSettings copyWith({
    String? userName,
    TimeOfDay? notificationTime,
    ThemeMode? themeMode,
  }) {
    return UserSettings(
      userName: userName ?? this.userName,
      notificationTime: notificationTime ?? this.notificationTime,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
