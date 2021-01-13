import 'dart:convert';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/widgets/object_grid.dart';
import 'package:courseplease/screens/teacher/teacher.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/price_button.dart';
import 'package:courseplease/widgets/product_variants_line.dart';
import 'package:courseplease/widgets/rating_and_vote_count.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'image_grid.dart';
import '../models/filters/photo.dart';
import '../models/filters/teacher.dart';
import '../models/interfaces.dart';
import '../models/teacher.dart';

class TeacherGrid extends StatefulWidget {
  TeacherFilter filter;

  TeacherGrid({@required this.filter}) : super(key: ValueKey(filter.toString()));

  @override
  State<TeacherGrid> createState() {
    return new TeacherGridState();
  }
}

class TeacherGridState extends State<TeacherGrid> {
  //DownloadedObjectList<int, Teacher, TeacherFilter> _downloadedObjectList;
  final padding = 5.0;

  @override
  void initState() {
    // _downloadedObjectList = DownloadedObjectList<int, Teacher, TeacherFilter>(
    //   repository: GetIt.instance.get<TeacherRepository>(),
    //   filter: widget.filter,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: ObjectGrid<int, Teacher, TeacherFilter, TeacherRepository, TeacherTile>(
        filter: widget.filter,
        //downloadedObjectList: _downloadedObjectList,
        tileFactory: ({Teacher object, int index, TileCallback<int, Teacher>onTap}) => TeacherTile(object: object, filter: widget.filter, index: index, onTap: onTap),

        // When using Photo as argument type, for some reason an exception is thrown
        // at tile construction in ObjectGird in GridView.builder:
        //
        // type '(Teacher, int) => Null' is not a subtype of type '(WithId<dynamic>, int) => void'
        // TODO: Find the reason for the exception, change the argument type to Teacher.
        onTap: (WithId teacher, int index) {
          if (teacher is Teacher) {
            _handleTap(teacher, index);
          } else {
            throw Exception('A teacher is not Teacher');
          }
        },

        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: padding,
          crossAxisSpacing: padding,
          childAspectRatio: 1.6,
        ),
      ),
    );
  }

  void _handleTap(Teacher teacher, int index) {
    Navigator.of(context).pushNamed(
      TeacherScreen.routeName,
      arguments: TeacherScreenArguments(
        id: teacher.id,
        subjectId: widget.filter.subjectId,
      ),
    );
  }
}

class TeacherTile extends AbstractObjectTile<int, Teacher, TeacherFilter> {
  TeacherTile({@required object, @required filter, @required index, onTap}) : super(object: object, filter: filter, index: index, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    final relativeUrl = object.userpicUrls['300x300'] ?? null;
    final url = relativeUrl == null ? null : 'https://courseplease.com' + relativeUrl;

    return GestureDetector(
      onTap: () => onTap(object, index),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(30, 128, 128, 128),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: url == null ? null : NetworkImage(url),
                    ),
                  ),
                  RatingAndVoteCountWidget(rating: object.rating, hideIfEmpty: true),
                  // RatingWidget(object.rating),
                  // UserCountWidget(object.rating.voteCount),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(object.firstName + ' ' + object.lastName + ' ' + object.id.toString(), style: TextStyle(fontWeight: FontWeight.bold))
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: LocationLineWidget(location: object.location, textOpacity: .5),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TeacherPhotoStripeWidget(
                      teacherFilter: filter,
                      teacherId: object.id,
                      height: 50,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ProductVariantsLineWidget(formats: object.productVariantFormats),
                  ),
                  _getPriceButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPriceButton() {
    if (object.maxPrice.isZero()) return Container();

    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(bottom: 10),
      child: PriceButton(money: object.maxPrice),
    );
  }
}


class TeacherPhotoStripeWidget extends StatelessWidget {
  final TeacherFilter teacherFilter;
  final int teacherId;
  final double height;

  TeacherPhotoStripeWidget({@required this.teacherFilter, @required this.teacherId, @required this.height});

  @override
  Widget build(BuildContext context) {
    var i = 0;
    return Container(
      height: this.height,
      child: PhotoGrid(
        filter: PhotoFilter(subjectId: teacherFilter.subjectId, teacherId: teacherId),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
      ),
    );
  }
}
