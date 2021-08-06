import 'dart:developer';
import 'dart:io';

import 'package:auto_gallery/app_routes.dart';
import 'package:auto_gallery/app_theme.dart';
import 'package:auto_gallery/db/db_config.dart';
import 'package:auto_gallery/db/image_model.dart';
import 'package:auto_gallery/date_names.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/show_empty.dart';
import 'widgets/show_loading.dart';

enum CtxEntries { autoExpiry, expirySettings }

extension CtxEntry on CtxEntries {
  String get name {
    switch (this) {
      case CtxEntries.autoExpiry:
        return 'Run Auto Expiry';
      case CtxEntries.expirySettings:
        return 'Auto Expiry Settings';
    }
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables
  final List<CtxEntries> _contextMenuEntries = [
    CtxEntries.autoExpiry,
    CtxEntries.expirySettings
  ];
  List<String> imageDateClass = <String>[];
  Map<String, List<AutoImage>> imageDateObj = <String, List<AutoImage>>{};
  List<AutoImage> tempClass = <AutoImage>[];

  //Getters
  Container get _topbar => Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(),
            const Text(
              'AG',
              style: TextStyle(
                  fontFamily: 'Berky', fontSize: 50, color: kPrimaryColor),
            ),
            PopupMenuButton(
              onSelected: _contextMenuAction,
              itemBuilder: (_) =>
                  _contextMenuEntries.map(contextMenuBuilder).toList(),
              child: const Icon(
                Icons.arrow_drop_down_circle_outlined,
                size: 30,
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      );

  Padding get _imageList => Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: imageDateClass.length,
            itemBuilder: monthAndDateBuilder,
          ),
        ),
      );

  //Widget Builder Functions
  PopupMenuItem<CtxEntries> contextMenuBuilder(CtxEntries entry) =>
      PopupMenuItem<CtxEntries>(
        value: entry,
        child: Text(entry.name),
      );

  Widget monthAndDateBuilder(BuildContext context, int index) {
    final List<String> monthAndDate = imageDateClass[index].split('**');
    final List<AutoImage>? images = imageDateObj[imageDateClass[index]];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Text(
          monthNames[int.parse(monthAndDate.last)],
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Text(monthAndDate.first),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: images?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 2.5, crossAxisSpacing: 2.5),
            itemBuilder: (context, index) =>
                imageBuilder(context, images?[index]))
      ],
    );
  }

  Widget imageBuilder(BuildContext context, AutoImage? image) {
    return GestureDetector(
      onTap: () => _showImageDetails(image),
      child: Container(
        color: kFadedAccent,
        child: Image.file(
          File(image?.path ?? ''),
          fit: BoxFit.fill,
          frameBuilder: (ctx, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.bounceOut,
              child: child,
            );
          },
          errorBuilder: (ctx, obj, stack) => const Center(
            child: Text(
              'File does not exist',
              style: TextStyle(color: kErrorColor, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //Top Bar
              _topbar,

              FutureBuilder<Box<AutoImage>>(
                future: _openBox(),
                builder: (context, snapshot) {
                  switch (snapshot.data?.length) {
                    case null:
                      return showLoading;
                    case 0:
                      return showEmpty;
                    default:
                      if (!isFormatted) _formatData(snapshot.data);
                      return _imageList;
                  }
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewImage,
        child: const Icon(Icons.add),
      ),
    );
  }

  //Program Logic Functions
  Future<Box<AutoImage>> _openBox() async =>
      Hive.openBox<AutoImage>(kImageBoxName);

  bool isFormatted = false;
  void _formatData(Box<AutoImage>? data) {
    isFormatted = true;
    data?.toMap().forEach((key, value) {
      final String _dateYear =
          '${value.dateTaken.year}**${value.dateTaken.month}';
      if (!imageDateClass.contains(_dateYear)) {
        if (imageDateClass.isNotEmpty) {
          final Map<String, List<AutoImage>> dateObj =
              <String, List<AutoImage>>{imageDateClass.last: tempClass};
          imageDateObj.addAll(dateObj);
        }
        imageDateClass.add(_dateYear);
        tempClass = [];
      }
      tempClass.add(value);
    });
    if (tempClass.isNotEmpty) {
      final Map<String, List<AutoImage>> dateObj = <String, List<AutoImage>>{
        imageDateClass.last: tempClass
      };
      imageDateObj.addAll(dateObj);
      tempClass = [];
    }
    imageDateClass = List<String>.from(imageDateClass.reversed);
    log(imageDateObj.toString());
  }

  void _contextMenuAction(CtxEntries value) {}

  Future<void> _addNewImage() async {
    //Taking photo
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    //Finding date and path
    final Directory _dir = await getApplicationDocumentsDirectory();
    final DateTime _now = DateTime.now();
    final String _path = '${_dir.path}/${_now.toIso8601String()}.jpg';
    await photo?.saveTo(_path);

    //Adding to database
    await Hive.box<AutoImage>(kImageBoxName).add(AutoImage(_now, _path));
    setState(() {
      isFormatted = false;
      imageDateClass = [];
    });
  }

  void _showImageDetails(AutoImage? image) {
    Navigator.pushNamed(context, kImageDetailsRoute, arguments: image);
  }
}
