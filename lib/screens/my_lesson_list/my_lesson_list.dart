import 'dart:async';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/create_lesson/create_lesson.dart';
import 'package:courseplease/screens/my_lesson_list/local_widgets/title.dart';
import 'package:courseplease/widgets/lesson/my_lesson_grid.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'local_blocs/lesson_list_action.dart';
import 'local_widgets/sorted_lesson_list_toolbar.dart';

class MyLessonListScreen extends StatefulWidget {
  final MyLessonFilter filter;
  final Map<int, EditableContact> contactsByIds;

  MyLessonListScreen({
    required this.filter,
    required this.contactsByIds,
  });

  @override
  State<MyLessonListScreen> createState() => _MyLessonListScreenState();

  static Future<void> show({
    required BuildContext context,
    required MyLessonFilter filter,
    Map<int, EditableContact>? contactsByIds,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => MyLessonListScreen(
          filter: filter,
          contactsByIds: contactsByIds ?? Map<int, EditableContact>(),
        ),
      ),
    );
  }
}

class _MyLessonListScreenState extends State<MyLessonListScreen> {
  final _selectableListCubit = SelectableListCubit<int, MyLessonFilter>(initialFilter: MyLessonFilter());
  late final LessonListActionCubit _listActionCubit;

  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  _MyLessonListScreenState() {
    _selectableListCubit.emptied.listen((_) => _onEmptied());
  }

  @override
  void initState() {
    super.initState();
    _selectableListCubit.setFilter(widget.filter);
    _productSubjectsByIdsBloc.setCurrentIds(widget.filter.subjectIds);
    _listActionCubit = LessonListActionCubit(filter: widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleWidget(
          filter: widget.filter,
          contactsByIds: widget.contactsByIds,
          productSubjectsByIdsBloc: _productSubjectsByIdsBloc,
        ),
      ),
      body: Column(
        children: [
          _buildActionToolbar(),
          Expanded(
            child: MyLessonGrid(
              filter: widget.filter,
              scrollDirection: Axis.vertical,
              crossAxisCount: 4,
              listStateCubit: _selectableListCubit,
              showStatusOverlay: true,
              showMappingsOverlay: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionToolbar() {
    // TODO: Add a case for unsorted filter when we introduce unsorted lessons.
    // if (widget.filter.unsorted) {
    //   return UnsortedImageListToolbar(
    //     imageListActionCubit: _imageListActionCubit,
    //     selectableListCubit: _selectableListCubit,
    //   );
    // }

    return SortedLessonListToolbar(
      listActionCubit: _listActionCubit,
      selectableListCubit: _selectableListCubit,
      onCreatePressed: _onCreatePressed,
    );
  }

  void _onCreatePressed() {
    CreateLessonScreen.show(
      context: context,
      filter: widget.filter,
    );
  }

  void _onEmptied() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _selectableListCubit.dispose();
    _listActionCubit.dispose();
    _productSubjectsByIdsBloc.dispose();
    super.dispose();
  }
}
