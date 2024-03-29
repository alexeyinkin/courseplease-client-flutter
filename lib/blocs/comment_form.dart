import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/reaction/comment.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/services/auth/sign_in_or_call.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'authentication.dart';

class CommentFormCubit extends Bloc {
  final _statesController = BehaviorSubject<CommentFormCubitState>();
  Stream<CommentFormCubitState> get states => _statesController.stream;

  final _resultsController = BehaviorSubject<DialogResult>();
  Stream<DialogResult> get results => _resultsController.stream;

  final _apiClient = GetIt.instance.get<ApiClient>();
  final _cache = GetIt.instance.get<FilteredModelListCache>();
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  final CommentFilter filter;
  final _controller = TextEditingController();
  bool _isTextEmpty = true;
  bool _inProgress = false;
  Comment? _currentComment;

  late final CommentFormCubitState initialState;

  final maxLength = 3000;

  CommentFormCubit({
    required this.filter,
  }) {
    _controller.addListener(_onTextChanged);
    initialState = _createState();
  }

  void _onTextChanged() {
    final isTextEmpty = (_controller.text == '');
    if (_isTextEmpty != isTextEmpty) {
      _isTextEmpty = isTextEmpty;
      _pushOutput();
    }
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  CommentFormCubitState _createState() {
    return CommentFormCubitState(
      controller: _controller,
      canSubmit: _getCanSubmit(),
      inProgress: _inProgress,
    );
  }

  bool _getCanSubmit() {
    if (_controller.text == '') return false;
    if (_inProgress) return false;
    return true;
  }

  void submit() {
    if (!_getCanSubmit()) return;

    SignInOrCallService().callOrSignInAndCall(
      SignInOrCallEvent(
        callback: _submitAuthenticated,
      ),
    );
  }

  void _submitAuthenticated() async {
    _inProgress = true;
    _pushOutput();

    final authorId = _authenticationCubit.currentState.data?.user?.id;
    if (authorId == null) {
      throw Exception('Should only get here if authenticated.');
    }

    _currentComment = Comment(
      id: 0,
      text: shortenIfLonger(_controller.text, maxLength),
      dateTimeInsert: DateTime.now(),
      authorId: authorId,
      likeCount: 0,
      isLiked: false,
      loadTimestampMilliseconds: 0,
    );

    final request = CreateCommentRequest(
      catalog: filter.catalog,
      objectId: filter.objectId,
      text: _currentComment!.text,
    );

    try {
      final response = await _apiClient.createComment(request);
      _onSuccess(response);
    } catch (e) {
      _handleError();
    }
  }

  void _onSuccess(CreateCommentResponse response) {
    _addCommentsToLists(response);

    _controller.text = '';
    _inProgress = false;

    _pushOutput();
    _resultsController.sink.add(DialogResult(code: DialogResultCode.ok));
  }

  void _addCommentsToLists(CreateCommentResponse response) {
    final comment = Comment(
      id: response.commentId,
      text: _currentComment!.text,
      dateTimeInsert: DateTime.now(),
      authorId: _currentComment!.authorId,
      likeCount: 0,
      isLiked: false,
      loadTimestampMilliseconds: DateTime.now().millisecondsSinceEpoch,
    );

    final commentLists = _cache.getModelListsByObjectAndFilterTypes<int, Comment, CommentFilter>();
    for (final list in commentLists.values) {
      if (filter.toString() != list.filter.toString()) continue;
      list.addToEnd([comment]);
    }
  }

  void _handleError() {
    _inProgress = false;
    _resultsController.sink.add(DialogResult(code: DialogResultCode.error));
    _pushOutput();
  }

  @override
  void dispose() {
    _statesController.close();
    _resultsController.close();
  }
}

class CommentFormCubitState {
  final TextEditingController controller;
  final bool canSubmit;
  final bool inProgress;

  CommentFormCubitState({
    required this.controller,
    required this.canSubmit,
    required this.inProgress,
  });
}
