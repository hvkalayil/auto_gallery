import 'package:auto_gallery/app_theme.dart';
import 'package:flutter/material.dart';

enum SortMode { dateAscending, dateDescending }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SortMode _mode = SortMode.dateDescending;
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
            IconButton(
              onPressed: openContextMenu,
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                size: 30,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
      );

  Padding get _searchSort => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: Container(
                color: kPrimaryColor,
                child: IconButton(
                    splashColor: kPrimaryColor,
                    onPressed: toggleSortMode,
                    icon: const Icon(
                      Icons.sort,
                      color: kSecondaryColor,
                      size: 30,
                    )),
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: const TextField(
                decoration: InputDecoration(
                    hintText: 'Search Date',
                    fillColor: kSecondaryColor,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: kRoundedRadius)),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //Top Bar
            _topbar,

            //  Search And Sort
            _searchSort,

            //  Image List
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: monthAndDateBuilder,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewImage,
        child: const Icon(Icons.add),
      ),
    );
  }

  void addNewImage() {
    print('Hey');
  }

  void openContextMenu() {
    print('Context Menu');
  }

  void toggleSortMode() {
    final SortMode _newMode = _mode == SortMode.dateAscending
        ? SortMode.dateDescending
        : SortMode.dateAscending;
    setState(() {
      _mode = _newMode;
    });
    print(_mode.toString());
  }

  Widget monthAndDateBuilder(BuildContext context, int index) {
    return Column(
      children: [
        Text('Month'),
        GridView.builder(
            shrinkWrap: true,
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 2.5, crossAxisSpacing: 2.5),
            itemBuilder: imageBuilder)
      ],
    );
  }

  Widget imageBuilder(BuildContext context, int index) {
    return Container(
        color: kPrimaryColor,
        child: Image.network(
            'https://yt3.ggpht.com/ytc/AKedOLQZjveT1nGwvlp8fGCI6Bzh5zTEoNnT_jp3kgxT=s900-c-k-c0x00ffffff-no-rj'));
  }
}
