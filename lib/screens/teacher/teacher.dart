import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/price_button.dart';
import 'package:courseplease/widgets/rating_and_vote_count.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import '../../widgets/image_grid.dart';
import '../../widgets/lesson_grid.dart';
import '../../models/filters/lesson.dart';
import '../../models/filters/photo.dart';
import '../../models/product_subject.dart';
import '../../models/teacher.dart';
import '../../models/teacher_subject.dart';

class TeacherScreen extends StatefulWidget {
  static const routeName = '/teacherById';

  @override
  State<TeacherScreen> createState() {
    return _TeacherScreenState();
  }
}

class _TeacherScreenState extends State<TeacherScreen> {
  final _teacherByIdBloc = ModelByIdBloc<int, Teacher>(
    modelCacheBloc: GetIt.instance.get<ModelCacheFactory>().getOrCreate<int, Teacher, TeacherRepository>(),
  );
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  int _teacherId;
  int _subjectId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _teacherByIdBloc.outState,
      initialData: _teacherByIdBloc.initialState,
      builder: (context, snapshot) =>
          _buildWithTeacherState(context, snapshot.data),
    );
  }

  Widget _buildWithTeacherState(BuildContext context, ModelByIdState<int, Teacher> teacherByIdState) {
    _startLoadingIfNot(context);

    final teacher = teacherByIdState.object;

    return teacher == null
        ? _buildWithoutTeacher(context, teacherByIdState)
        : _buildWithTeacher(context, teacher);
  }

  Widget _buildWithoutTeacher(BuildContext context, ModelByIdState<int, Teacher> teacherByIdState) {
    switch (teacherByIdState.requestStatus) {
      case RequestStatus.notTried:
      case RequestStatus.loading:
        return SmallCircularProgressIndicator();
      default:
        return Center(child: Icon(Icons.error));
    }
  }

  Widget _buildWithTeacher(BuildContext context, Teacher teacher) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        _getUserpic(teacher),
                        RatingAndVoteCountWidget(rating: teacher.rating, hideIfEmpty: true),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getNameStripe(teacher),
                        _getSubjectsLine(teacher),
                        _getLocationLine(teacher),
                        _getBio(teacher),
                        _getFormatList(teacher),
                      ],
                    ),
                  ),
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

  Widget _getUserpic(Teacher teacher) {
    final userpicUrlTail = teacher.userpicUrls['300x300'] ?? null;
    final userpicUrl = userpicUrlTail == null ? null : 'https://courseplease.com' + userpicUrlTail;

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: CircleAvatar(
        radius: 100,
        backgroundImage: userpicUrl == null ? null : NetworkImage(userpicUrl),
      ),
    );
  }

  Widget _getNameStripe(Teacher teacher) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Text(
        teacher.firstName + ' ' + teacher.lastName,
        style: AppStyle.pageTitle,
      ),
    );
  }

  Widget _getSubjectsLine(Teacher teacher) {
    _productSubjectsByIdsBloc.setCurrentIds(teacher.subjectIds);
    return StreamBuilder(
      stream: _productSubjectsByIdsBloc.outState,
      initialData: _productSubjectsByIdsBloc.initialState,
      builder: (context, snapshot) => _buildSubjectLineWithState(snapshot.data),
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
            child: CapsulesWidget(objects: subjects, selectedId: _subjectId, onTap: _setCategory),
          ),
        ],
      ),
    );
  }

  void _setCategory(ProductSubject subject) {
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
    TeacherSubject tc = _getSelectedTeacherSubject(teacher);
    String markdown = (tc != null && tc.body != '') ? tc.body : teacher.bio;

    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Markdown(data: markdown, shrinkWrap: true),
    );
  }

  Widget _getFormatList(Teacher teacher) {
    final tc = _getSelectedTeacherSubject(teacher);
    if (tc == null) return _getFormatListPlaceholder('Not currently teaching.');
    if (tc.productVariantFormats.isEmpty) return _getFormatListPlaceholder('Not currently teaching this subject. Try other categories or teachers.');

    final children = <ListTile>[];

    for (final format in tc.productVariantFormats) {
      children.add(
        ListTile(
          title: Text(format.title),
          trailing: PriceButton(money: format.maxPrice, per: 'h'),
        ),
      );
    }
    return Column(
      children: children,
    );
  }

  Widget _getFormatListPlaceholder(String text) {
    return Text(text);
  }

  Widget _getLessonsBlock() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 300,
      ),
      child: LessonGrid(
        filter: LessonFilter(subjectId: _subjectId, teacherId: _teacherId),
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
      child: PhotoGrid(
        filter: PhotoFilter(subjectId: _subjectId, teacherId: _teacherId),
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

  // Nullable
  TeacherSubject _getSelectedTeacherSubject(Teacher teacher) {
    if (_subjectId == null) return null;

    for (final teacherSubject in teacher.categories) {
      if (teacherSubject.subjectId == _subjectId) return teacherSubject;
    }
    return null;
  }

  void _startLoadingIfNot(BuildContext context) {
    if (_teacherId == null) {
      final arguments = ModalRoute.of(context).settings.arguments as TeacherScreenArguments;
      _teacherId = arguments.id;
      _subjectId = arguments.subjectId;
      _loadTeacher();
    }
  }

  void _loadTeacher() async {
    _teacherByIdBloc.setCurrentId(_teacherId);
  }

  @override
  void dispose() {
    super.dispose();
    _teacherByIdBloc.dispose();
  }
}

class TeacherScreenArguments {
  final int id;
  final int subjectId;
  TeacherScreenArguments({this.id, this.subjectId});
}
