import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/breadcrumbs.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';

import 'bloc.dart';
import 'explore_tab_enum.dart';
import 'local_widgets/explore_root_tab.dart';
import 'local_widgets/images_tab.dart';
import 'local_widgets/lessons_tab.dart';
import 'local_widgets/teachers_tab.dart';

class ExploreScreen extends StatefulWidget {
  final ExploreBloc cubit;

  ExploreScreen({
    required this.cubit,
  });

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with TickerProviderStateMixin {
  /// Animates tab switches. The source of truth for the current tab
  /// is in widget.state.tabController, but it has no animation
  /// because logic classes have no animation ticker.
  /// This one replicates it with animation.
  late KeyedTabController<ExploreTab> _tabController;

  @override
  void initState() {
    _tabController = KeyedTabController<ExploreTab>(
      initialKey: widget.cubit.tabController.currentKey,
      keys: widget.cubit.tabController.keys,
      vsync: this,
    );

    // TODO: Add something like KeyedStaticTabController.addAnimatedController().
    widget.cubit.tabController.addListener(_onStaticControllerChanged);
    _tabController.addListener(_onAnimatedControllerChanged);
    super.initState();
  }

  void _onStaticControllerChanged() {
    _tabController.updateFromStatic(widget.cubit.tabController);
  }

  void _onAnimatedControllerChanged() {
    // TODO: Call once only. This now happens twice during tab switch.
    widget.cubit.tabController.updateFromAnimated(_tabController);
  }

  @override
  void dispose() {
    widget.cubit.tabController.removeListener(_onStaticControllerChanged);
    _tabController.removeListener(_onAnimatedControllerChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TreePositionState<int, ProductSubject>>(
      stream: widget.cubit.currentTreePositionBloc.states,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? widget.cubit.currentTreePositionBloc.initialState,
      ),
    );
  }

  Widget _buildWithState(TreePositionState<int, ProductSubject> state) {
    if (state.currentId != null) return _buildNonRoot(state);

    return ExploreRootTabWidget(
      treePositionState: state,
      onSubjectChanged: widget.cubit.currentTreePositionBloc.setCurrentId,
    );
  }

  Widget _buildNonRoot(TreePositionState<int, ProductSubject> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BreadcrumbsWidget(
          treePositionState: state,
          onChanged: widget.cubit.currentTreePositionBloc.setCurrentId,
        ),
        _buildChildrenSubjectsLine(state),
        KeyedTabBar(
          tabs: _getTabTitles(),
          controller: _tabController,
        ),
        Expanded(
          child: KeyedTabBarView(
            children: _getTabContents(state),
            controller: _tabController,
          ),
        ),
      ],
    );
  }

  Map<ExploreTab, Widget> _getTabTitles() {
    return {
      ExploreTab.images: Tab(text: tr('ImagesTabWidget.title')),
      ExploreTab.lessons: Tab(text: tr('LessonsTabWidget.title')),
      ExploreTab.teachers: Tab(text: tr('TeachersTabWidget.title')),
    };
  }

  Map<ExploreTab, Widget> _getTabContents(TreePositionState<int, ProductSubject> state) {
    return {
      ExploreTab.images: ImagesTab(treePositionState: state, cubit: widget.cubit.imagesTabCubit),
      ExploreTab.lessons: LessonsTab(treePositionState: state, cubit: widget.cubit.lessonsTabCubit),
      ExploreTab.teachers: TeachersTab(treePositionState: state, cubit: widget.cubit.teachersTabCubit),
    };
  }

  Widget _buildChildrenSubjectsLine(TreePositionState<int, ProductSubject> state) {
    return CapsulesWidget<int, ProductSubject>(
      objects: state.currentChildren,
      onTap: (subject) => widget.cubit.currentTreePositionBloc.setCurrentId(subject.id),
    );
  }
}
