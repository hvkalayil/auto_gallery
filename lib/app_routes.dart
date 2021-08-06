import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/image_details_screen.dart';

const String kHomePageRoute = 'Home Page';
const String kImageDetailsRoute = 'Image Details Page';

Map<String, Widget Function(BuildContext)> appRoutes = {
  kHomePageRoute: (_) => HomeScreen(),
  kImageDetailsRoute: (_) => const ImageDetailsScreen()
};
