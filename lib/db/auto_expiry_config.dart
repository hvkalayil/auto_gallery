import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
