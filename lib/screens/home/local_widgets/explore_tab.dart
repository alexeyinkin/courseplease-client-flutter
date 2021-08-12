import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/screens/home/local_widgets/images_tab.dart';
import 'package:courseplease/widgets/breadcrumbs.dart';
import 'package:courseplease/screens/home/local_widgets/teachers_tab.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../blocs/tree_position.dart';
import 'lessons_tab.dart';
import '../../../models/product_subject.dart';

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _currentTreePositionBloc = TreePositionBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TreePositionState<int, ProductSubject>>(
      stream: _currentTreePositionBloc.states,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? _currentTreePositionBloc.initialState,
      ),
    );
  }

  Widget _buildWithState(TreePositionState<int, ProductSubject> state) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadcrumbsWidget(
            treePositionState: state,
            onChanged: _currentTreePositionBloc.setCurrentId,
          ),
          _buildChildrenSubjectsLine(state),
          TabBar(
            tabs: [
              Tab(text: tr('ImagesTabWidget.title')),
              Tab(text: tr('TeachersTabWidget.title')),
              Tab(text: tr('LessonsTabWidget.title')),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ImagesTab(treePositionState: state),
                TeachersTab(treePositionState: state),
                LessonsTab(treePositionState: state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenSubjectsLine(TreePositionState<int, ProductSubject> state) {
    return CapsulesWidget<int, ProductSubject>(
      objects: state.currentChildren,
      onTap: (subject) => _currentTreePositionBloc.setCurrentId(subject.id),
    );
  }
}
