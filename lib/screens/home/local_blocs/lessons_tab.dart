import 'package:courseplease/blocs/filterable.dart';
import 'package:courseplease/blocs/text_change_debouncer.dart';
import 'package:courseplease/models/filters/gallery_lesson.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class LessonsTabCubit extends FilterableCubit<GalleryLessonFilter> {
  final _statesController = BehaviorSubject<LessonsTabCubitState>();
  Stream<LessonsTabCubitState> get states => _statesController.stream;
  late final LessonsTabCubitState initialState;

  GalleryLessonFilter _filterWithoutSearch;
  final _searchController = TextEditingController();
  late final TextChangeDebouncer _searchDebouncer;

  LessonsTabCubit({
    required GalleryLessonFilter initialFilter,
  }) :
      _filterWithoutSearch = initialFilter
  {
    initialState = _createState();
    _searchDebouncer = TextChangeDebouncer(textEditingController: _searchController, onChanged: _onSearchChanged);
  }

  void _onSearchChanged() {
    _pushOutput();
  }

  void setFilter(GalleryLessonFilter filter) {
    _filterWithoutSearch = filter;
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  LessonsTabCubitState _createState() {
    return LessonsTabCubitState(
      filter: _createFilter(),
      searchController: _searchController,
    );
  }

  GalleryLessonFilter _createFilter() {
    return _filterWithoutSearch.withSearch(_searchController.text);
  }

  @override
  void dispose() {
    _statesController.close();
    _searchController.dispose();
    _searchDebouncer.dispose();
  }
}

class LessonsTabCubitState extends FilterableCubitState<GalleryLessonFilter>{
  final GalleryLessonFilter filter;
  final TextEditingController searchController;

  LessonsTabCubitState({
    required this.filter,
    required this.searchController,
  });
}
