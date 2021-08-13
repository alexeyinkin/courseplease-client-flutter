import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/widgets/object_grid.dart';
import 'package:courseplease/screens/teacher/teacher.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/price_button.dart';
import 'package:courseplease/widgets/product_variants_line.dart';
import 'package:courseplease/widgets/teacher_rating_and_customer_count.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../models/filters/gallery_image.dart';
import '../models/filters/teacher.dart';
import '../models/teacher.dart';
import 'media/image/gallery_image_grid.dart';

class TeacherGrid extends StatefulWidget {
  final TeacherFilter filter;
  final ProductSubject? productSubject;

  TeacherGrid({
    required this.filter,
    required this.productSubject,
  }) : super(key: ValueKey(filter.toString()));

  @override
  State<TeacherGrid> createState() {
    return new TeacherGridState();
  }
}

class TeacherGridState extends State<TeacherGrid> {
  final padding = 5.0;

  @override
  Widget build(BuildContext context) {
    return _isFilterValid(widget.filter)
        ? _buildWithFilter()
        : Container();
  }

  static bool _isFilterValid(TeacherFilter filter) {
    return filter.subjectId != null;
  }

  Widget _buildWithFilter() {
    final subjectAndDescendantIds = widget.productSubject?.getThisAndDescendantIdsMap();

    return Container(
      padding: EdgeInsets.all(padding),
      child: ObjectGrid<int, Teacher, TeacherFilter, TeacherRepository, TeacherTile>(
        filter: widget.filter,
        tileFactory: (request) => _createTile(request, subjectAndDescendantIds),
        onTap: _handleTap,
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

  TeacherTile _createTile(
    TileCreationRequest<int, Teacher, TeacherFilter> request,
    Map<int, void>? subjectAndDescendantIds,
  ) {
    return TeacherTile(
      request: request,
      subjectAndDescendantIds: subjectAndDescendantIds,
    );
  }

  void _handleTap(Teacher teacher, int index) {
    TeacherScreen.show(
      context: context,
      teacherId: teacher.id,
      initialSubjectId: widget.filter.subjectId,
    );
  }
}

class TeacherTile extends AbstractObjectTile<int, Teacher, TeacherFilter> {
  final Map<int, void>? subjectAndDescendantIds;

  TeacherTile({
    required TileCreationRequest<int, Teacher, TeacherFilter> request,
    required this.subjectAndDescendantIds,
  }) : super(
    request: request,
  );

  @override
  State<AbstractObjectTile> createState() => TeacherTileState();
}

class TeacherTileState extends AbstractObjectTileState<int, Teacher, TeacherFilter, TeacherTile> {
  @override
  Widget build(BuildContext context) {
    final user = widget.object;
    final relativeUrl = user.userpicUrls['300x300'] ?? null;
    final url = relativeUrl == null ? null : 'https://courseplease.com' + relativeUrl;
    final ts = TeacherSubject.mergeWithSubjectIds(user.subjects, widget.subjectAndDescendantIds);

    return GestureDetector(
      onTap: widget.onTap,
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
                  TeacherRatingAndCustomerCountWidget(teacher: user),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(user.firstName + ' ' + user.lastName + ' ' + user.id.toString(), style: TextStyle(fontWeight: FontWeight.bold))
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: LocationLineWidget(location: user.location, textOpacity: .5),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TeacherImageLineWidget(
                      teacherFilter: widget.filter,
                      teacherId: user.id,
                      height: 50,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ProductVariantsLineWidget(formats: ts.productVariantFormats),
                  ),
                  _getPriceButton(ts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPriceButton(TeacherSubject ts) {
    final maxPrice = _getMaxPrice(ts);
    if (maxPrice == null) return Container();

    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(bottom: 10),
      child: PriceButton(
        money: maxPrice,
        per: tr('util.units.h'),
        onPressed: widget.onTap,
      ),
    );
  }

  Money? _getMaxPrice(TeacherSubject ts) {
    var money = Money({});

    for (final pv in ts.productVariantFormats) {
      if (pv.enabled == false || pv.maxPrice == null) continue;
      if (pv.maxPrice!.gt(money)) money = pv.maxPrice!;
    }

    return money.isZero() ? null : money;
  }
}


class TeacherImageLineWidget extends StatelessWidget {
  final TeacherFilter teacherFilter;
  final int teacherId;
  final double height;

  TeacherImageLineWidget({
    required this.teacherFilter,
    required this.teacherId,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    var i = 0;
    return Container(
      height: this.height,
      child: GalleryImageGrid(
        filter: GalleryImageFilter(
          subjectId: teacherFilter.subjectId,
          teacherId: teacherId,
          purposeId: ImageAlbumPurpose.portfolio,
        ),
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
