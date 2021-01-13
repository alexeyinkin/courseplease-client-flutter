import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/screens/home/local_widgets/photos_tab.dart';
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
  // int _subjectId = 7;
  // int _tabIndex = 0;
  CurrentProductSubjectBloc _bloc;

  @override
  void initState() {
    _bloc = _createCurrentProductSubjectBloc();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //key: PageStorageKey('h'),
      child: Provider.value(
        value: _bloc,
        child: DefaultTabController(
          //key: PageStorageKey('c'),
          length: 3,
          child: Column(
            //key: PageStorageKey('d'),
            children: [
              ProductSubjectsBreadcrumbs(
                // topLevelSubjects: widget.topLevelSubjects,
                // selectedSubject: widget.categoryProvider.getById(_subjectId),
                // onTap: _setSelectedSubjectId,
              ),
              _getChildrenSubjectsLine(context),
              TabBar(
                tabs: [
                  Tab(text: 'Works'),
                  Tab(text: 'Teachers'),
                  Tab(text: 'Lessons'),
                ],
              ),
              Expanded(
                //key: PageStorageKey('a'),
                child: TabBarView(
                  //key: PageStorageKey('b'),
                  children: [
                    PhotosTab(),
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
    productSubjectCacheBloc.outObjectsByIds.listen(bloc.inSubjectsByIds.add);
    //GetIt.instance.get<ProductSubjectsBloc>().outSubjectsByIds.listen(bloc.inSubjectsByIds.add);

    // GetIt.instance.get<ProductSubjectsBloc>().outSubjectsByIds.listen((map) {
    //   bloc.inSubjectsByIds.add(map);
    //   print(map);
    // });
    return bloc;
  }

  Widget _getChildrenSubjectsLine(BuildContext context) {
    //final bloc = BlocProvider.of<CurrentProductSubjectBloc>(context);

    return StreamBuilder<List<ProductSubject>>(
      stream: _bloc.outChildren,
      initialData: <ProductSubject>[],
      builder: (context, snapshot) {
        return CapsulesWidget<int, ProductSubject>(
          objects: snapshot.data,
          onTap: (subject) => _bloc.inCurrentId.add(subject.id),
        );
      },
    );
  }
}
