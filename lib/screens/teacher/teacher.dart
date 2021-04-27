import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/shop/line_item.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/screens/order/order.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/profile.dart';
import 'package:courseplease/widgets/rating_and_vote_count.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/teacher_subject_product_variants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import '../../widgets/image_grid.dart';
import '../../widgets/lesson_grid.dart';
import '../../models/filters/lesson.dart';
import '../../models/filters/image.dart';
import '../../models/product_subject.dart';
import '../../models/teacher.dart';
import '../../models/teacher_subject.dart';

class TeacherScreen extends StatefulWidget {
  static const routeName = '/teacherById';

  final int teacherId;
  final int? initialSubjectId;

  TeacherScreen({
    required this.teacherId,
    required this.initialSubjectId,
  });

  @override
  _TeacherScreenState createState() => _TeacherScreenState(
    teacherId: teacherId,
    subjectId: initialSubjectId,
  );

  static Future<void> show({
    required BuildContext context,
    required int teacherId,
    required int? initialSubjectId,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherScreen(
          teacherId: teacherId,
          initialSubjectId: initialSubjectId,
        ),
      ),
    );
  }
}

class _TeacherScreenState extends State<TeacherScreen> {
  final _teacherByIdBloc = ModelByIdBloc<int, Teacher>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Teacher, TeacherRepository>(),
  );
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  int? _subjectId;

  _TeacherScreenState({
    required int teacherId,
    required int? subjectId,
  }) :
      _subjectId = subjectId
  {
    _teacherByIdBloc.setCurrentId(teacherId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelByIdState<int, Teacher>>(
      stream: _teacherByIdBloc.outState,
      builder: (context, snapshot) => _buildWithTeacherState(
        snapshot.data ?? _teacherByIdBloc.initialState,
      ),
    );
  }

  Widget _buildWithTeacherState(ModelByIdState<int, Teacher> teacherByIdState) {
    final teacher = teacherByIdState.object;

    return teacher == null
        ? _buildWithoutTeacher(teacherByIdState)
        : _buildWithTeacher(teacher);
  }

  Widget _buildWithoutTeacher(ModelByIdState<int, Teacher> teacherByIdState) {
    switch (teacherByIdState.requestStatus) {
      case RequestStatus.notTried:
      case RequestStatus.loading:
        return SmallCircularProgressIndicator();
      default:
        return Center(child: Icon(Icons.error));
    }
  }

  Widget _buildWithTeacher(Teacher teacher) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileWidget(
                user: teacher,
                childrenUnderUserpic: [
                  RatingAndVoteCountWidget(rating: teacher.rating, hideIfEmpty: true),
                ],
                childrenUnderName: [
                  _getSubjectsLine(teacher),
                  _getLocationLine(teacher),
                  _getBio(teacher),
                  _getFormatList(teacher),
                ],
              ),
              _getLessonsBlock(),
              _getWorksBlock(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSubjectsLine(Teacher teacher) {
    _productSubjectsByIdsBloc.setCurrentIds(teacher.subjectIds);
    return StreamBuilder<ModelListByIdsState<ProductSubject>>(
      stream: _productSubjectsByIdsBloc.outState,
      builder: (context, snapshot) => _buildSubjectLineWithState(
        snapshot.data ?? _productSubjectsByIdsBloc.initialState,
      ),
    );
  }

  Widget _buildSubjectLineWithState(ModelListByIdsState<ProductSubject> listState) {
    return _buildSubjectLineWithSubjects(listState.objects);
  }

  Widget _buildSubjectLineWithSubjects(List<ProductSubject> subjects) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text('Teaches'),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: CapsulesWidget(objects: subjects, selectedId: _subjectId, onTap: _setSubject),
          ),
        ],
      ),
    );
  }

  void _setSubject(ProductSubject subject) {
    setState(() {
      _subjectId = subject.id;
    });
  }

  Widget _getLocationLine(Teacher teacher) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: LocationLineWidget(location: teacher.location),
    );
  }

  Widget _getBio(Teacher teacher) {
    TeacherSubject? tc = _getSelectedTeacherSubject(teacher);
    String markdown = (tc != null && tc.body != '') ? tc.body : teacher.bio;

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Markdown(data: markdown, shrinkWrap: true),
    );
  }

  Widget _getFormatList(Teacher teacher) {
    final ts = _getSelectedTeacherSubject(teacher);
    if (ts == null) {
      return _getFormatListPlaceholder(tr('TeacherScreen.notCurrentlyTeaching'));
    }
    if (ts.productVariantFormats.isEmpty) {
      return _getFormatListPlaceholder(tr('TeacherScreen.notCurrentlyTeachingThis'));
    }

    return TeacherSubjectProductVariantsWidget(
      teacherSubject: ts,
      onPressed: (format) => _onFormatPressed(ts.subjectId, format, teacher),
    );
  }

  Widget _getFormatListPlaceholder(String text) {
    return Text(text);
  }

  void _onFormatPressed(
    int productSubjectId,
    ProductVariantFormatWithPrice format,
    Teacher teacher,
  ) {
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

  Widget _getLessonsBlock() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300,
      ),
      child: LessonGrid(
        filter: LessonFilter(subjectId: _subjectId, teacherId: widget.teacherId),
        titleIfNotEmpty: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: Text('My Lessons', style: AppStyle.h2),
        ),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
      ),
    );
  }

  Widget _getWorksBlock() {
    return Container(
      height: 200,
      child: ViewImageGrid(
        filter: ViewImageFilter(subjectId: _subjectId, teacherId: widget.teacherId),
        titleIfNotEmpty: Container(
          padding: EdgeInsets.only(bottom: 5),
          child: Text('My Works', style: AppStyle.h2),
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

  TeacherSubject? _getSelectedTeacherSubject(Teacher teacher) {
    if (_subjectId == null) return null;

    for (final teacherSubject in teacher.categories) {
      if (teacherSubject.subjectId == _subjectId) return teacherSubject;
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    _productSubjectsByIdsBloc.dispose();
    _teacherByIdBloc.dispose();
  }
}
