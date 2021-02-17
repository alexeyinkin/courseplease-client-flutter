import 'package:courseplease/models/filters/image.dart';
import 'package:flutter/widgets.dart';
import 'image_grid.dart';

class UnsortedMediaPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EditImageGrid(
      filter: EditImageFilter(unsorted: true),
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 3,
        crossAxisSpacing: 1,
      ),
    );
  }
}
