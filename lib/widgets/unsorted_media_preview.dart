import 'package:courseplease/models/filters/my_image.dart';
import 'package:flutter/widgets.dart';
import 'media/image/my_image_grid.dart';

class UnsortedMediaPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyImageGrid(
      filter: MyImageFilter(unsorted: true),
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 3,
        crossAxisSpacing: 1,
      ),
    );
  }
}
