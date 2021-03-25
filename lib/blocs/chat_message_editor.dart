import 'dart:async';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/services/chat_message_draft_persister.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'chats.dart';

class ChatMessageEditorCubit extends Bloc {
  final int chatId;
  final int senderUserId;

  final _textEditingController = TextEditingController();
  Timer? _textEditingDebounce;

  final _chatsCubit = GetIt.instance.get<ChatsCubit>();
  final _persister = GetIt.instance.get<ChatMessageDraftPersisterService>();
  final _uuidGenerator = Uuid();

  final _outStateController = BehaviorSubject<ChatMessageEditorState>();
  Stream<ChatMessageEditorState> get outState => _outStateController.stream;

  static const _saveDebounceDuration = const Duration(milliseconds: 1000);

  ChatMessageEditorCubit({
    required this.chatId,
    required this.senderUserId,
  }) {
    _init();
  }

  void _init() async {
    final draft = await _persister.getDraftByChatId(chatId);
    if (draft != null) {
      _fillWithDraft(draft);
    }
    _textEditingController.addListener(_onTextChanged);
    _pushOutput();
  }

  void _fillWithDraft(SendingChatMessage draft) {
    _textEditingController.text = draft.body.text;
  }

  void _onTextChanged() {
    if (_isEmpty()) {
      _deleteDraft();
      return;
    }

    if (_textEditingDebounce?.isActive ?? false) _textEditingDebounce!.cancel();
    _textEditingDebounce = Timer(_saveDebounceDuration, () {
      _saveDraft();
    });
  }

  void _deleteDraft() {
    _persister.deleteDraftByChatId(chatId);
  }

  void _saveDraft() {
    final message = _createMessage();

    if (message == null) {
      _deleteDraft();
    } else {
      _persister.saveDraft(message);
    }
  }

  void _pushOutput() {
    final state = _createState();
    _outStateController.sink.add(state);
  }

  ChatMessageEditorState _createState() {
    return ChatMessageEditorState(
      textEditingController: _textEditingController,
    );
  }

  void onSendPressed() {
    final message = _createMessage();
    if (message == null) return;

    _chatsCubit.send(message);
    _clear();
  }

  bool _isEmpty() {
    return _textEditingController.text.trim() == '';
  }

  SendingChatMessage? _createMessage() {
    final text = _textEditingController.text.trim();
    if (text == '') return null;

    return SendingChatMessage(
      senderUserId:     senderUserId,
      recipientChatId:  chatId,
      recipientUserId:  null,
      body: MessageBody(
        text: text,
      ),
      uuid: _uuidGenerator.v4(),
      status: SendingChatMessageStatus.readyToSend,
    );
  }

  void _clear() {
    _textEditingController.text = ''; // Also triggers draft deletion.
  }

  @override
  void dispose() {
    _outStateController.close();
    _textEditingDebounce?.cancel();
    _textEditingController.dispose();
  }
}

class ChatMessageEditorState {
  final TextEditingController textEditingController;

  ChatMessageEditorState({
    required this.textEditingController,
  });
}
