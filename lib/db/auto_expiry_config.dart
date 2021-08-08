import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Duration
const String kExpiryDurationKey = 'Auto Expiry Duration Key';
Future<Duration> getAutoExpiryDuration() async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  final int _days = _prefs.getInt(kExpiryDurationKey) ?? 60;
  return Duration(days: _days);
}

Future<int> getAutoExpiryDays() async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getInt(kExpiryDurationKey) ?? 60;
}

Future<void> setAutoExpiryDuration(int days, BuildContext ctx) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setInt(kExpiryDurationKey, days);
  Navigator.pop(ctx);
}

//File Path
const String kSavedFolderPathKey = 'Saved Folder Key';

Future<String> getFolderPath() async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  String? _path = _prefs.getString(kSavedFolderPathKey);
  if (_path == null) {
    final Directory _dir = await getApplicationDocumentsDirectory();
    _path = _dir.path;
  }
  return _path;
}

Future<void> setFolderPath(String value) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString(kSavedFolderPathKey, value);
}
