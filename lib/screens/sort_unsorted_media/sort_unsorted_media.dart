import 'package:courseplease/widgets/image_grid.dart';
import 'package:flutter/material.dart';

class SortUnsortedMediaScreen extends StatefulWidget {
  static const routeName = '/sortUnsortedMedia';

  @override
  State<SortUnsortedMediaScreen> createState() => _SortUnsortedMediaScreenState();
}

class _SortUnsortedMediaScreenState extends State<SortUnsortedMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sort Imported Media"),
      ),
      body: UnsortedPhotoGrid(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
      ),
    );
  }
}
