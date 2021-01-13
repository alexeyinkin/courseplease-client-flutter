import 'package:courseplease/blocs/current_product_subject.dart';
import 'package:flutter/material.dart';
import '../../../widgets/image_grid.dart';
import '../../../models/filters/photo.dart';
import 'package:provider/provider.dart';

//class PhotosTab extends StatefulWidget {
class PhotosTab extends StatelessWidget {
  //int subjectId;

  // PhotosTab({
  //   Key key,
  //   @required this.subjectId,
  // }) : super(key: key);

//   @override
//   State<PhotosTab> createState() {
//     return PhotosTabState();
//   }
// }
//
// class PhotosTabState extends State<PhotosTab> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<CurrentProductSubjectBloc>();

    return Center(
      //key: PageStorageKey('e'),
      child: StreamBuilder<int>(
        stream: bloc.outCurrentId,
        builder: (context, snapshot) {
          return PhotoGrid(
            filter: PhotoFilter(subjectId: snapshot.data),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
          );
        }
      ),
    );
  }
}
