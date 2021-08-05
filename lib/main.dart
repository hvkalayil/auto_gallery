import 'package:flutter/material.dart';

import 'app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Gallery',
      debugShowCheckedModeBanner: false,
      routes: appRoutes,
      initialRoute: kHomePageRoute,
    );
  }
}
