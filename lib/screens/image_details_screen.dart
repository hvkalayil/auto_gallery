import 'dart:io';

import 'package:auto_gallery/app_theme.dart';
import 'package:auto_gallery/date_names.dart';
import 'package:auto_gallery/db/db_config.dart';
import 'package:auto_gallery/db/image_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ImageDetailsScreen extends StatelessWidget {
  const ImageDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AutoImage _image =
        // ignore: cast_nullable_to_non_nullable
        ModalRoute.of(context)!.settings.arguments as AutoImage;

    final String _dateString =
        '${_image.dateTaken.day} ${monthNames[_image.dateTaken.month]} ${_image.dateTaken.year}';
    final String _weekDay = weekNames[_image.dateTaken.weekday];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: kBorderRadius(tl: 0, tr: 0),
                    child: Image.file(
                      File(_image.path),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: ClipOval(
                          child: Container(
                            color: kSecondaryColor,
                            child: const Icon(
                              Icons.close,
                              size: 32,
                              color: kPrimaryColor,
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),

            //Info Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //Date Info
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _dateString,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 25),
                      ),
                      Text(
                        _weekDay,
                        style: const TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),

                //Buttons
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () async => _shareImage(_image.path),
                      icon: const Icon(Icons.share),
                      tooltip: 'Share',
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => _deleteImage(context, _image.key),
                      icon: const Icon(Icons.delete),
                      tooltip: 'Delete',
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareImage(String path) async => Share.shareFiles([path]);

  Future<void> _deleteImage(BuildContext context, key) async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this image'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(_), child: const Text('No')),
                TextButton(
                    onPressed: () async {
                      final Box<AutoImage> _box =
                          await Hive.openBox<AutoImage>(kImageBoxName);
                      await _box.delete(key);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: const Text('Yes')),
              ],
            ));
  }
}
