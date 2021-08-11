import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/text_change_debouncer.dart';
import 'package:courseplease/models/external_lesson.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/create_lesson.dart';
import 'package:courseplease/services/net/api_client/lesson_info.dart';
import 'package:courseplease/services/net/api_client/parse_external_lesson.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class CreateLessonScreenCubit extends Bloc {
  final _statesController = BehaviorSubject<CreateLessonScreenCubitState>();
  Stream<CreateLessonScreenCubitState> get states => _statesController.stream;

  final _errorsController = BehaviorSubject<void>();
  Stream<void> get errors => _errorsController.stream;

  final _successesController = BehaviorSubject<void>();
  Stream<void> get successes => _successesController.stream;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _apiClient = GetIt.instance.get<ApiClient>();

  late final CreateLessonScreenCubitState initialState;

  final _urlController = TextEditingController();
  late final TextChangeDebouncer _urlDebouncer;

  int? _subjectId;
  ExternalLesson? _externalLesson;
  CreateLessonScreenAction? _actionInProgress;

  CreateLessonScreenCubit({
    int? initialSubjectId,
  }) :
      _subjectId = initialSubjectId
  {
    initialState = _createState();
    _urlDebouncer = TextChangeDebouncer(textEditingController: _urlController, onChanged: _onUrlChanged);
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  CreateLessonScreenCubitState _createState() {
    return CreateLessonScreenCubitState(
      urlController:    _urlController,
      subjectId:        _subjectId,
      externalLesson:   _externalLesson,
      canProceed:       _getCanProceed(),
      actionInProgress: _actionInProgress,
    );
  }

  bool _getCanProceed() {
    if (_externalLesson == null) return false;
    if (_subjectId == null) return false;
    if (_actionInProgress != null) return false;
    return true;
  }

  void _onUrlChanged() async {
    if (!_isUrlValid()) {
      _externalLesson = null;
      _pushOutput();
      return;
    }

    _actionInProgress = CreateLessonScreenAction.parsing;
    _pushOutput();

    try {
      final request = ParseExternalLessonRequest(url: _urlController.text);
      _externalLesson = await _apiClient.parseExternalLesson(request);
    } catch (ex) {
      _externalLesson = null;
    }

    _actionInProgress = null;
    _pushOutput();
  }

  bool _isUrlValid() {
    return _urlController.text != '';
  }

  void setSubjectId(int subjectId) {
    if (subjectId == _subjectId) return;
    _subjectId = subjectId;
    _pushOutput();
  }

  void proceed() async {
    if (!_getCanProceed()) return;

    final request = CreateLessonRequest(
      url: _urlController.text,
      info: LessonInfo(
        subjectId: _subjectId!,
      ),
    );

    _actionInProgress = CreateLessonScreenAction.saving;
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
    _urlDebouncer.dispose();
    _statesController.close();
    _errorsController.close();
    _successesController.close();
    _urlController.dispose();
  }
}

class CreateLessonScreenCubitState {
  final TextEditingController urlController;
  final int? subjectId;
  final ExternalLesson? externalLesson;
  final bool canProceed;
  final CreateLessonScreenAction? actionInProgress;

  CreateLessonScreenCubitState({
    required this.urlController,
    required this.subjectId,
    required this.externalLesson,
    required this.canProceed,
    required this.actionInProgress,
  });
}

enum CreateLessonScreenAction {
  parsing,
  saving,
}
