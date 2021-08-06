import 'package:flutter/material.dart';

Padding get showLoading => const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Center(child: CircularProgressIndicator()),
    );
