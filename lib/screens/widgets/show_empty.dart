import 'package:flutter/material.dart';

Widget get showEmpty => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 50),
        Image.asset('assets/Empty.gif'),
        const Text('There are no images. Take a few snaps 📷')
      ],
    );
