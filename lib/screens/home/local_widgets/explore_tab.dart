import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/screens/home/local_widgets/images_tab.dart';
import 'package:courseplease/screens/home/local_widgets/product_subjects_breadcrumbs.dart';
import 'package:courseplease/screens/home/local_widgets/teachers_tab.dart';
import 'package:courseplease/widgets/capsules.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../blocs/current_product_subject.dart';
import 'lessons_tab.dart';
import '../../../models/product_subject.dart';

class ExploreTab extends StatefulWidget {
  @override
  State<ExploreTab> createState() => ExploreTabState();
}

class ExploreTabState extends State<ExploreTab> {
  CurrentProductSubjectBloc _bloc;

  @override
  void initState() {
    _bloc = _createCurrentProductSubjectBloc();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Provider.value(
        value: _bloc,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              ProductSubjectsBreadcrumbs(),
              _getChildrenSubjectsLine(context),
              TabBar(
                tabs: [
                  Tab(text: 'Works'),
                  Tab(text: 'Teachers'),
                  Tab(text: 'Lessons'),
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
      ),
    );
  }

  CurrentProductSubjectBloc _createCurrentProductSubjectBloc() {
    final bloc = CurrentProductSubjectBloc();

    final productSubjectCacheBloc = GetIt.instance.get<ProductSubjectCacheBloc>();
    productSubjectCacheBloc.outObjectsByIds.listen(bloc.setSubjectsByIds);

    return bloc;
  }

  Widget _getChildrenSubjectsLine(BuildContext context) {
    return StreamBuilder<List<ProductSubject>>(
      stream: _bloc.outChildren,
      initialData: <ProductSubject>[],
      builder: (context, snapshot) {
        return CapsulesWidget<int, ProductSubject>(
          objects: snapshot.data,
          onTap: (subject) => _bloc.setCurrentId(subject.id),
        );
      },
    );
  }
}
