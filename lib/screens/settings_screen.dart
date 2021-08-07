import 'dart:async';

import 'package:auto_gallery/app_theme.dart';
import 'package:auto_gallery/db/auto_expiry_config.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpirySettingsScreen extends StatefulWidget {
  const ExpirySettingsScreen({Key? key}) : super(key: key);

  static const List<int> _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  static const List<String> _titles = ['Set Auto Expiry Duration', 'Review'];
  static const List<IconData> _icons = [Icons.access_time, Icons.star];

  @override
  _ExpirySettingsScreenState createState() => _ExpirySettingsScreenState();
}

class _ExpirySettingsScreenState extends State<ExpirySettingsScreen> {
  ListView get _listOfSettings => ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => ListTile(
            leading: Icon(ExpirySettingsScreen._icons[index]),
            title: Text(ExpirySettingsScreen._titles[index]),
            onTap: () => _handleEntryClick(context, index),
          ),
      separatorBuilder: (context, index) => const Divider(
            color: kPrimaryColor,
            thickness: 5,
          ),
      itemCount: ExpirySettingsScreen._titles.length);

  GestureDetector get _easterEgg => GestureDetector(
        onDoubleTap: _showDetails,
        child: AnimatedContainer(
          color: _animate ? kPrimaryColor : Colors.white,
          padding: const EdgeInsets.all(20),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeIn,
          child: Column(
            children: const <Widget>[
              Text(
                'AG',
                style: TextStyle(
                    fontFamily: 'Berky', fontSize: 40, color: Colors.white70),
              ),
              Text(
                'Version 1',
                style: TextStyle(color: kSecondaryColor),
              ),
              Text(
                'made by HVK',
                style: TextStyle(color: kSecondaryColor),
              )
            ],
          ),
        ),
      );

  bool _animate = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _animate = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            _listOfSettings,
            const SizedBox(height: 300),
            _easterEgg
          ]),
        ),
      ),
    );
  }

  Future<void> _handleEntryClick(BuildContext context, int index) async {
    switch (index) {
      case 0:
        final int _current = await getAutoExpiryDays();
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Change Duration'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Change duration of auto-expiry'),
                      DropdownButton<int>(
                          value: _current,
                          onChanged: (days) =>
                              setAutoExpiryDuration(days ?? 30, _),
                          items: ExpirySettingsScreen._months
                              .map((e) => DropdownMenuItem<int>(
                                  value: e * 30, child: Text('$e month')))
                              .toList())
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    )
                  ],
                ));
        break;

      case 1:
        await StoreRedirect.redirect(
            androidAppId: 'com.hoseavarghese.auto_gallery');
        break;
    }
  }

  void _showDetails() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Easter Egg'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/easter.png'),
                  const Text(
                    '🥳 You just found a easter egg. Contact me and I will sent you something',
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                      onPressed: () => launch('https://hvkalayil.github.io/'),
                      child: const Text('Contact HVK'))
                ],
              ),
            ));
  }
}
