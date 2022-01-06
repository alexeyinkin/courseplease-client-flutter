import 'package:courseplease/blocs/filterable.dart';
import 'package:courseplease/blocs/text_change_debouncer.dart';
import 'package:courseplease/models/filters/teacher.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class TeachersTabCubit extends FilterableCubit<TeacherFilter> {
  final _statesController = BehaviorSubject<TeachersTabCubitState>();
  Stream<TeachersTabCubitState> get states => _statesController.stream;
  late final TeachersTabCubitState initialState;

  TeacherFilter _filterWithoutSearch;
  final _searchController = TextEditingController();
  late final TextChangeDebouncer _searchDebouncer;

  TeachersTabCubit({
    required TeacherFilter initialFilter,
  }) :
      _filterWithoutSearch = initialFilter
  {
    initialState = _createState();
    _searchDebouncer = TextChangeDebouncer(textEditingController: _searchController, onChanged: _onSearchChanged);
  }

  void _onSearchChanged() {
    _pushOutput();
  }

  void setFilter(TeacherFilter filter) {
    _filterWithoutSearch = filter;
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  TeachersTabCubitState _createState() {
    return TeachersTabCubitState(
      filter: _createFilter(),
      searchController: _searchController,
    );
  }

  TeacherFilter _createFilter() {
    return _filterWithoutSearch.withSearch(_searchController.text);
  }

  @override
  void dispose() {
    _statesController.close();
    _searchController.dispose();
    _searchDebouncer.dispose();
  }
}

class TeachersTabCubitState extends FilterableCubitState<TeacherFilter>{
  final TeacherFilter filter;
  final TextEditingController searchController;

  TeachersTabCubitState({
    required this.filter,
    required this.searchController,
  });
}
