import 'package:auto_gallery/db/image_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'app_routes.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AutoImageAdapter());
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
      theme: ThemeData(fontFamily: 'Monty'),
    );
  }
}
