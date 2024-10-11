import 'package:flutter/material.dart';

class UserSettings {
  final String userName;
  final TimeOfDay notificationTime;

  UserSettings({
    this.userName = '',
    this.notificationTime = const TimeOfDay(hour: 9, minute: 0),
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'notificationTime': '${notificationTime.hour}:${notificationTime.minute}',
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
    );
  }
}
