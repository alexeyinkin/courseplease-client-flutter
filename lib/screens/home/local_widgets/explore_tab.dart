import 'package:courseplease/screens/home/local_widgets/images_tab.dart';
import 'package:courseplease/screens/home/local_widgets/product_subjects_breadcrumbs.dart';
import 'package:courseplease/screens/home/local_widgets/teachers_tab.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../blocs/current_product_subject.dart';
import 'lessons_tab.dart';
import '../../../models/product_subject.dart';

class ExploreTab extends StatefulWidget {
  @override
  State<ExploreTab> createState() => ExploreTabState();
}

class ExploreTabState extends State<ExploreTab> {
  final CurrentProductSubjectBloc _bloc = CurrentProductSubjectBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _bloc,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            ProductSubjectsBreadcrumbs(),
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
      stream: _bloc.outChildren,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return SmallCircularProgressIndicator(scale: .5);
        }
        return CapsulesWidget<int, ProductSubject>(
          objects: snapshot.data!,
          onTap: (subject) => _bloc.setCurrentId(subject.id),
        );
      },
    );
  }
}
