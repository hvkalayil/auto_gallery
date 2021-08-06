import 'package:flutter/material.dart';

const Color kPrimaryColor = Colors.blueAccent;
final Color kFadedAccent = Colors.blue.shade100;
const Color kSecondaryColor = Colors.white;
const Color kErrorColor = Colors.redAccent;
BorderRadius kBorderRadius(
        {double tl = 20, double tr = 20, double bl = 20, double br = 20}) =>
    BorderRadius.only(
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
        bottomLeft: Radius.circular(bl),
        bottomRight: Radius.circular(br));
