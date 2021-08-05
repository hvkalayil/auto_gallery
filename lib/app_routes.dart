import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

const String kHomePageRoute = 'Home Page';
Map<String, Widget Function(BuildContext)> appRoutes = {
  kHomePageRoute: (_) => HomeScreen()
};
