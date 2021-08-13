import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/screens/home/local_widgets/explore_root_tab.dart';
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
    return state.currentId == null
        ? ExploreRootTabWidget(treePositionState: state, onSubjectChanged: _currentTreePositionBloc.setCurrentId)
        : _buildNonRoot(state);
  }

  Widget _buildNonRoot(TreePositionState<int, ProductSubject> state) {
    return DefaultTabController(
      length: _getTabCount(state),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BreadcrumbsWidget(
            treePositionState: state,
            onChanged: _currentTreePositionBloc.setCurrentId,
          ),
          _buildChildrenSubjectsLine(state),
          TabBar(
            tabs: _getTabTitles(state),
          ),
          Expanded(
            child: TabBarView(
              children: _getTabContents(state),
            ),
          ),
        ],
      ),
    );
  }

  int _getTabCount(TreePositionState<int, ProductSubject> state) {
    // Always present:
    //   Lessons
    //   Teachers
    int result = 2;

    if (state.currentObject?.allowsImagePortfolio ?? false) {
      result++;
    }

    return result;
  }

  List<Widget> _getTabTitles(TreePositionState<int, ProductSubject> state) {
    final result = <Widget>[];

    if (state.currentObject?.allowsImagePortfolio ?? false) {
      result.add(Tab(text: tr('ImagesTabWidget.title')));
    }

    result.add(Tab(text: tr('LessonsTabWidget.title')));
    result.add(Tab(text: tr('TeachersTabWidget.title')));

    return result;
  }

  List<Widget> _getTabContents(TreePositionState<int, ProductSubject> state) {
    final result = <Widget>[];

    if (state.currentObject?.allowsImagePortfolio ?? false) {
      result.add(ImagesTab(treePositionState: state));
    }

    result.add(LessonsTab(treePositionState: state));
    result.add(TeachersTab(treePositionState: state));

    return result;
  }

  Widget _buildChildrenSubjectsLine(TreePositionState<int, ProductSubject> state) {
    return CapsulesWidget<int, ProductSubject>(
      objects: state.currentChildren,
      onTap: (subject) => _currentTreePositionBloc.setCurrentId(subject.id),
    );
  }
}
