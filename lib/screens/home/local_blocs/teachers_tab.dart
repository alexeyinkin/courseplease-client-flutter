import 'package:courseplease/blocs/filterable.dart';
import 'package:courseplease/models/filters/teacher.dart';
import 'package:rxdart/rxdart.dart';

class TeachersTabCubit extends FilterableCubit<TeacherFilter> {
  final _statesController = BehaviorSubject<TeachersTabCubitState>();
  Stream<TeachersTabCubitState> get states => _statesController.stream;
  late final TeachersTabCubitState initialState;

  TeacherFilter _filter;

  TeachersTabCubit({
    required TeacherFilter initialFilter,
  }) :
      _filter = initialFilter
  {
    initialState = _createState();
  }

  void setFilter(TeacherFilter filter) {
    _filter = filter;
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  TeachersTabCubitState _createState() {
    return TeachersTabCubitState(
      filter: _filter,
    );
  }

  @override
  void dispose() {
    _statesController.close();
  }
}

class TeachersTabCubitState extends FilterableCubitState<TeacherFilter>{
  final TeacherFilter filter;

  TeachersTabCubitState({
    required this.filter,
  });
}
