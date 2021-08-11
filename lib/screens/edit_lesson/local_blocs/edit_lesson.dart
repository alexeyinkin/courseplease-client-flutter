import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/edit_lesson.dart';
import 'package:courseplease/services/net/api_client/lesson_info.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class EditLessonScreenCubit extends Bloc {
  final _statesController = BehaviorSubject<EditLessonScreenCubitState>();
  Stream<EditLessonScreenCubitState> get states => _statesController.stream;

  final _errorsController = BehaviorSubject<void>();
  Stream<void> get errors => _errorsController.stream;

  final _successesController = BehaviorSubject<void>();
  Stream<void> get successes => _successesController.stream;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _apiClient = GetIt.instance.get<ApiClient>();

  late final EditLessonScreenCubitState initialState;

  final Lesson lesson;
  int? _subjectId;
  EditLessonScreenAction? _actionInProgress;

  EditLessonScreenCubit({
    required this.lesson,
  }) :
      _subjectId = lesson.subjectId
  {
    initialState = _createState();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  EditLessonScreenCubitState _createState() {
    return EditLessonScreenCubitState(
      subjectId: _subjectId,
      canProceed: _getCanProceed(),
      actionInProgress: _actionInProgress,
    );
  }

  bool _getCanProceed() {
    if (_subjectId == null) return false;
    if (_actionInProgress != null) return false;
    if (!_isChanged()) return false;
    return true;
  }

  bool _isChanged() {
    if (_subjectId != lesson.subjectId) return true;
    return false;
  }

  void setSubjectId(int? subjectId) {
    if (subjectId == _subjectId) return;
    _subjectId = subjectId;
    _pushOutput();
  }

  void proceed() async {
    if (!_getCanProceed()) return;

    final request = EditLessonRequest(
      id: lesson.id,
      info: LessonInfo(
        subjectId: _subjectId!,
      ),
    );

    _actionInProgress = EditLessonScreenAction.saving;
    _pushOutput();

    try {
      await _apiClient.createLesson(request);
      _successesController.sink.add(true);
      _reloadLists();
    } catch (ex) {
      _actionInProgress = null;
      _pushOutput();
      _errorsController.sink.add(true);
    }
  }

  void _reloadLists() {
    _authenticationCubit.reloadCurrentActor(); // Could have added a subject.

    final cache = GetIt.instance.get<FilteredModelListCache>();
    final lists = cache.getModelListsByObjectAndFilterTypes<int, Lesson, MyLessonFilter>();

    for (final list in lists.values) {
      // Calling just .clear() would empty the list in MyLessonListScreen and close it in _onEmptied.
      list.clearAndLoadFirstPage();
    }
  }

  @override
  void dispose() {
    _statesController.close();
    _errorsController.close();
    _successesController.close();
  }
}

class EditLessonScreenCubitState {
  final int? subjectId;
  final bool canProceed;
  final EditLessonScreenAction? actionInProgress;

  EditLessonScreenCubitState({
    required this.subjectId,
    required this.canProceed,
    required this.actionInProgress,
  });
}

enum EditLessonScreenAction {
  saving,
}
