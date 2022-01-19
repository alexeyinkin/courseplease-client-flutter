import 'package:collection/collection.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/create_lesson/page.dart';
import 'package:courseplease/screens/my_lesson_list/bloc.dart';
import 'package:courseplease/screens/my_lesson_list/local_widgets/title.dart';
import 'package:courseplease/widgets/auth/sign_in_if_not.dart';
import 'package:courseplease/widgets/lesson/my_lesson_grid.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'local_widgets/sorted_lesson_list_toolbar.dart';

// TODO: Close on selectableListCubit.emptied
class MyLessonListScreen extends StatefulWidget {
  final MyLessonListBloc bloc;

  MyLessonListScreen({
    required this.bloc,
  });

  @override
  State<MyLessonListScreen> createState() => _MyLessonListScreenState();
}

class _MyLessonListScreenState extends State<MyLessonListScreen> {
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  @override
  void initState() {
    super.initState();
    _productSubjectsByIdsBloc.setCurrentIds(widget.bloc.filter.subjectIds);
  }

  @override
  Widget build(BuildContext context) {
    return SignInIfNotWidget(signedInBuilder: _buildAuthenticated);
  }

  Widget _buildAuthenticated(BuildContext context, _) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.bloc.closeScreen),
        title: TitleWidget(
          filter: widget.bloc.filter,
          contactsByIds: <int, EditableContact>{},
          productSubjectsByIdsBloc: _productSubjectsByIdsBloc,
        ),
      ),
      body: Column(
        children: [
          _buildActionToolbar(),
          Expanded(
            child: MyLessonGrid(
              filter: widget.bloc.filter,
              scrollDirection: Axis.vertical,
              crossAxisCount: 4,
              listStateCubit: widget.bloc.selectableListCubit,
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
      listActionCubit: widget.bloc.listActionCubit,
      selectableListCubit: widget.bloc.selectableListCubit,
      onCreatePressed: _onCreatePressed,
    );
  }

  void _onCreatePressed() {
    GetIt.instance.get<AppState>().pushPage(
      CreateLessonPage(subjectId: widget.bloc.filter.subjectIds.firstOrNull),
    );
  }

  @override
  void dispose() {
    _productSubjectsByIdsBloc.dispose();
    super.dispose();
  }
}
