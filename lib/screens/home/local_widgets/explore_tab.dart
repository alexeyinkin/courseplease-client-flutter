import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/filters/gallery_lesson.dart';
import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/router/explore_tab_state.dart';
import 'package:courseplease/screens/home/local_blocs/images_tab.dart';
import 'package:courseplease/screens/home/local_blocs/lessons_tab.dart';
import 'package:courseplease/screens/home/local_blocs/teachers_tab.dart';
import 'package:courseplease/screens/home/local_widgets/explore_root_tab.dart';
import 'package:courseplease/screens/home/local_widgets/images_tab.dart';
import 'package:courseplease/widgets/breadcrumbs.dart';
import 'package:courseplease/screens/home/local_widgets/teachers_tab.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';
import '../../../blocs/tree_position.dart';
import 'lessons_tab.dart';
import '../../../models/product_subject.dart';

class ExploreTabWidget extends StatefulWidget {
  final ExploreTabState state;

  ExploreTabWidget({
    required this.state,
  });

  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTabWidget> with TickerProviderStateMixin {
  /// Animates tab switches. The source of truth for the current tab
  /// is in widget.state.tabController, but it has no animation
  /// because logic classes have no animation ticker.
  /// This one replicates it with animation.
  late KeyedTabController<ExploreTab> _tabController;

  final _imagesTabCubit = ImagesTabCubit(
    initialFilter: GalleryImageFilter(
      subjectId: null,
      purposeId: ImageAlbumPurpose.portfolio,
    ),
  );

  final _lessonsTabCubit = LessonsTabCubit(
    initialFilter: GalleryLessonFilter(
      subjectId: null,
    ),
  );

  final _teachersTabCubit = TeachersTabCubit(
    initialFilter: TeacherFilter(
      subjectId: null,
    ),
  );

  @override
  void initState() {
    _tabController = KeyedTabController<ExploreTab>(
      initialKey: widget.state.tabController.currentKey,
      keys: widget.state.tabController.keys,
      vsync: this,
    );

    widget.state.tabController.addListener(_onStaticControllerChanged);
    _tabController.addListener(_onAnimatedControllerChanged);
    super.initState();
  }

  void _onStaticControllerChanged() {
    _tabController.updateFromStatic(widget.state.tabController);
  }

  void _onAnimatedControllerChanged() {
    // TODO: Call once only. This now happens twice during tab switch.
    widget.state.tabController.updateFromAnimated(_tabController);
  }

  @override
  void dispose() {
    _imagesTabCubit.dispose();
    _teachersTabCubit.dispose();
    widget.state.tabController.removeListener(_onStaticControllerChanged);
    _tabController.removeListener(_onAnimatedControllerChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TreePositionState<int, ProductSubject>>(
      stream: widget.state.currentTreePositionBloc.states,
      builder: (context, snapshot) => _buildWithState(
        snapshot.data ?? widget.state.currentTreePositionBloc.initialState,
      ),
    );
  }

  Widget _buildWithState(TreePositionState<int, ProductSubject> state) {
    if (state.currentId != null) return _buildNonRoot(state);

    return ExploreRootTabWidget(
      treePositionState: state,
      onSubjectChanged: widget.state.currentTreePositionBloc.setCurrentId,
    );
  }

  Widget _buildNonRoot(TreePositionState<int, ProductSubject> state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BreadcrumbsWidget(
          treePositionState: state,
          onChanged: widget.state.currentTreePositionBloc.setCurrentId,
        ),
        _buildChildrenSubjectsLine(state),
        TabBar(
          tabs: _getTabTitles(state),
          controller: _tabController,
        ),
        Expanded(
          child: TabBarView(
            children: _getTabContents(state),
            controller: _tabController,
          ),
        ),
      ],
    );
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
      result.add(ImagesTab(treePositionState: state, cubit: _imagesTabCubit));
    }

    result.add(LessonsTab(treePositionState: state, cubit: _lessonsTabCubit));
    result.add(TeachersTab(treePositionState: state, cubit: _teachersTabCubit));

    return result;
  }

  Widget _buildChildrenSubjectsLine(TreePositionState<int, ProductSubject> state) {
    return CapsulesWidget<int, ProductSubject>(
      objects: state.currentChildren,
      onTap: (subject) => widget.state.currentTreePositionBloc.setCurrentId(subject.id),
    );
  }
}
