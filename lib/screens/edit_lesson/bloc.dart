import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/blocs/screen.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/repositories/my_lesson.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/edit_lesson/configurations.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/edit_lesson.dart';
import 'package:courseplease/services/net/api_client/lesson_info.dart';
import 'package:get_it/get_it.dart';

class EditLessonBloc extends AppScreenBloc<EditLessonCubitState> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _apiClient = GetIt.instance.get<ApiClient>();

  final initialState = EditLessonCubitState(
    lesson: null,
    subjectId: null,
    canProceed: false,
    actionInProgress: null,
  );

  final int lessonId;
  Lesson? _lesson;
  int? _subjectId;
  EditLessonScreenAction? _actionInProgress;

  final _modelByIdBloc = ModelByIdBloc<int, Lesson>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Lesson, MyLessonRepository>()
  );

  EditLessonBloc({
    required this.lessonId,
  }) {
    _modelByIdBloc.setCurrentId(lessonId);
    _modelByIdBloc.outState.listen(_onLessonChanged);
  }

  void _onLessonChanged(ModelByIdState<int, Lesson> state) {
    _lesson = state.object;
    if (_subjectId == null) _subjectId = _lesson?.subjectId;
    emitState();
  }

  @override
  EditLessonCubitState createState() {
    return EditLessonCubitState(
      lesson: _lesson,
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
    if (_lesson == null) return false;
    if (_subjectId != _lesson!.subjectId) return true;
    return false;
  }

  @override
  AppConfiguration get currentConfiguration {
    return EditLessonConfiguration(lessonId: lessonId);
  }

  void setSubjectId(int? subjectId) {
    if (subjectId == _subjectId) return;
    _subjectId = subjectId;
    emitState();
  }

  void proceed() async {
    if (!_getCanProceed()) return;

    final request = EditLessonRequest(
      id: lessonId,
      info: LessonInfo(
        subjectId: _subjectId!,
      ),
    );

    _actionInProgress = EditLessonScreenAction.saving;
    emitState();

    try {
      await _apiClient.createLesson(request);
      emitSaved();
      closeScreen();
      _reloadLists();
    } catch (ex) {
      _actionInProgress = null;
      emitState();
      emitUnknownError();
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
    _modelByIdBloc.dispose();
    super.dispose();
  }
}

class EditLessonCubitState {
  final Lesson? lesson;
  final int? subjectId;
  final bool canProceed;
  final EditLessonScreenAction? actionInProgress;

  EditLessonCubitState({
    required this.lesson,
    required this.subjectId,
    required this.canProceed,
    required this.actionInProgress,
  });
}

enum EditLessonScreenAction {
  saving,
}
