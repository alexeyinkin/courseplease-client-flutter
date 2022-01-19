import 'dart:async';

import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/blocs/text_change_debouncer.dart';
import 'package:courseplease/models/external_lesson.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/router/snack_event.dart';
import 'package:courseplease/screens/create_lesson/configurations.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/create_lesson.dart';
import 'package:courseplease/services/net/api_client/lesson_info.dart';
import 'package:courseplease/services/net/api_client/parse_external_lesson.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class CreateLessonBloc extends AppPageStatefulBloc<CreateLessonScreenCubitState> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  StreamSubscription? _authenticationSubscription;

  final _apiClient = GetIt.instance.get<ApiClient>();

  late final CreateLessonScreenCubitState initialState;

  final _urlController = TextEditingController();
  late final TextChangeDebouncer _urlDebouncer;

  int? _subjectId;
  ExternalLesson? _externalLesson;
  CreateLessonScreenAction? _actionInProgress;

  CreateLessonBloc({
    int? initialSubjectId,
  }) :
      _subjectId = initialSubjectId
  {
    initialState = createState();
    _urlDebouncer = TextChangeDebouncer(textEditingController: _urlController, onChanged: _onUrlChanged);

    _authenticationSubscription = _authenticationCubit.outState.listen(_onAuthenticationChanged);
    _onAuthenticationChanged(_authenticationCubit.currentState);
  }

  void _onAuthenticationChanged(AuthenticationState state) {
    if (state.data?.user == null) {
      closeScreen();
    }
  }

  @override
  MyPageConfiguration getConfiguration() {
    return CreateLessonConfiguration(
      subjectId: _subjectId,
    );
  }

  @override
  CreateLessonScreenCubitState createState() {
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
      emitState();
      return;
    }

    _actionInProgress = CreateLessonScreenAction.parsing;
    emitState();

    try {
      final request = ParseExternalLessonRequest(url: _urlController.text);
      _externalLesson = await _apiClient.parseExternalLesson(request);
    } catch (ex) {
      _externalLesson = null;
    }

    _actionInProgress = null;
    emitState();
  }

  bool _isUrlValid() {
    return _urlController.text.trim() != '';
  }

  void setSubjectId(int subjectId) {
    if (subjectId == _subjectId) return;
    _subjectId = subjectId;
    emitState();
    emitConfigurationChanged();
  }

  void proceed() async {
    if (!_getCanProceed()) return;

    final request = CreateLessonRequest(
      url: _urlController.text.trim(),
      info: LessonInfo(
        subjectId: _subjectId!,
      ),
    );

    _actionInProgress = CreateLessonScreenAction.saving;
    emitState();

    try {
      await _apiClient.createLesson(request);
      emitDone();
      closeScreen();
      _reloadLists();
    } catch (ex) {
      // TODO: Tell the exact error from network error.
      _actionInProgress = null;
      emitState();
      emitEvent(SnackEvent(type: SnackEventType.error, message: tr('CreateLessonScreen.errors.duplicate')));
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
    _urlController.dispose();
    _authenticationSubscription?.cancel();
    super.dispose();
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
