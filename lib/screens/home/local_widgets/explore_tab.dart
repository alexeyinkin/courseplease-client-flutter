import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/screens/home/local_widgets/images_tab.dart';
import 'package:courseplease/widgets/breadcrumbs.dart';
import 'package:courseplease/screens/home/local_widgets/teachers_tab.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
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
    // TODO: Start at root when the root screen is developed.
    currentId: 7,
  );

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _currentTreePositionBloc,
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BreadcrumbsWidget(currentTreePositionBloc: _currentTreePositionBloc),
            _getChildrenSubjectsLine(context),
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
                  ImagesTab(),
                  TeachersTab(),
                  LessonsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getChildrenSubjectsLine(BuildContext context) {
    return StreamBuilder<List<ProductSubject>>(
      stream: _currentTreePositionBloc.outChildren,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SmallCircularProgressIndicator(scale: .5);
        }
        return CapsulesWidget<int, ProductSubject>(
          objects: snapshot.data!,
          onTap: (subject) => _currentTreePositionBloc.setCurrentId(subject.id),
        );
      },
    );
  }
}
