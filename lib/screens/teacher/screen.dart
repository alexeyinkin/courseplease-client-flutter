import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/shop/line_item.dart';
import 'package:courseplease/screens/order/order.dart';
import 'package:courseplease/screens/teacher/bloc.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:courseplease/widgets/frames/framed_column.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/media/image/gallery_image_grid.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/profile.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/teacher_rating_and_customer_count.dart';
import 'package:courseplease/widgets/teacher_subject_product_variants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../widgets/lesson/gallery_lesson_grid.dart';
import '../../models/filters/gallery_lesson.dart';
import '../../models/filters/gallery_image.dart';
import '../../models/product_subject.dart';
import '../../models/teacher.dart';

class TeacherScreen extends StatelessWidget {
  final TeacherBloc cubit;

  TeacherScreen({
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<TeacherBlocState>(
          stream: cubit.states,
          builder: (context, snapshot) => _buildWithTeacherState(
            context,
            snapshot.data ?? cubit.initialState,
          ),
        ),
      ),
    );
  }

  Widget _buildWithTeacherState(BuildContext context, TeacherBlocState state) {
    final teacher = state.teacher;

    return teacher == null
        ? _buildWithoutTeacher(state)
        : _buildWithTeacher(context, state, teacher);
  }

  Widget _buildWithoutTeacher(TeacherBlocState state) {
    switch (state.requestStatus) {
      case RequestStatus.notTried:
      case RequestStatus.loading:
        return SmallCircularProgressIndicator();
      default:
        // TODO: Allow to retry.
        return Center(child: Icon(Icons.error));
    }
  }

  Widget _buildWithTeacher(BuildContext context, TeacherBlocState state, Teacher teacher) {
    return FramedColumn(
      children: [
        ProfileWidget(
          user: teacher,
          childrenUnderUserpic: [
            TeacherRatingAndCustomerCountWidget(teacher: teacher),
          ],
          childrenUnderName: [
            _getSubjectsLine(state),
            SmallPadding(),
            _getLocationLine(teacher),
            SmallPadding(),
            _getBio(state, teacher),
            _getFormatList(context, state, teacher),
          ],
        ),
        _getLessonsBlock(state),
        _getPortfolioBlock(state),
        _getCustomersPortfolioBlock(state),
        _getBackstageBlock(state),
      ],
    );
  }

  Widget _getSubjectsLine(TeacherBlocState state) {
    if (state.teacher!.subjectIds.isEmpty) {
      return Text(tr('TeacherScreen.student'));
    }

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(tr('TeacherScreen.teaches')),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: CapsulesWidget<int, ProductSubject>(
              objects: state.subjects,
              selectedId: state.selectedSubjectId,
              onTap: (subject) => cubit.setSubjectId(subject.id),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getLocationLine(Teacher teacher) {
    if (teacher.location.countryCode == '') return Container();

    return LocationLineWidget(location: teacher.location);
  }

  Widget _getBio(TeacherBlocState state, Teacher teacher) {
    final ts = state.selectedTeacherSubject;
    String markdown = (ts != null && ts.body != '')
        ? ts.body
        : teacher.bio;

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Markdown(data: markdown, shrinkWrap: true),
    );
  }

  Widget _getFormatList(BuildContext context, TeacherBlocState state, Teacher teacher) {
    if (teacher.subjectIds.isEmpty) return Container(); // A student.

    final ts = state.selectedTeacherSubject;
    if (ts == null || ts.productVariantFormats.isEmpty) {
      return _getFormatListPlaceholder(tr('TeacherScreen.notCurrentlyTeachingThis'));
    }

    return TeacherSubjectProductVariantsWidget(
      teacherSubject: ts,
      onPressed: (format) => _onFormatPressed(context, ts.subjectId, format, teacher),
    );
  }

  Widget _getFormatListPlaceholder(String text) {
    return Text(text);
  }

  void _onFormatPressed(
    BuildContext context,
    int productSubjectId,
    ProductVariantFormatWithPrice format,
    Teacher teacher,
  ) {
    // TODO: Check auth, show sign in if not.
    OrderScreen.show(
      context: context,
      lineItems: [
        LineItem(
          productVariantId: format.productVariantId!,
          productSubjectId: productSubjectId,
          format: format,
          user: teacher,
          quantity: 1,
        ),
      ],
    );
  }

  Widget _getLessonsBlock(TeacherBlocState state) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300,
      ),
      child: GalleryLessonGrid(
        filter: GalleryLessonFilter(subjectId: state.selectedSubjectId, teacherId: cubit.teacherId),
        titleIfNotEmpty: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: Text('TeacherScreen.subtitles.lessons', style: AppStyle.h2),
        ),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
      ),
    );
  }

  Widget _getPortfolioBlock(TeacherBlocState state) {
    if (!_supportsPortfolio(state)) return Container();
    return _getImageGrid(state, ImageAlbumPurpose.portfolio, 'portfolio');
  }

  Widget _getCustomersPortfolioBlock(TeacherBlocState state) {
    if (!_supportsPortfolio(state)) return Container();
    return _getImageGrid(state, ImageAlbumPurpose.customersPortfolio, 'customersPortfolio');
  }

  Widget _getBackstageBlock(TeacherBlocState state) {
    return _getImageGrid(state, ImageAlbumPurpose.backstage, 'backstage');
  }

  bool _supportsPortfolio(TeacherBlocState state) {
    return state.selectedSubject?.allowsImagePortfolio ?? false;
  }

  Widget _getImageGrid(
    TeacherBlocState state,
    int purposeId,
    String titleKeyTail,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200,
      ),
      child: GalleryImageGrid(
        filter: GalleryImageFilter(
          subjectId: state.selectedSubjectId,
          teacherId: cubit.teacherId,
          purposeId: purposeId,
        ),
        titleIfNotEmpty: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            tr('TeacherScreen.subtitles.' + titleKeyTail),
            style: AppStyle.h2,
          ),
        ),
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
      ),
    );
  }
}
