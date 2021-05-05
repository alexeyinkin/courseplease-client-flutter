import 'dart:async';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/chat_message_draft.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/services/chat_message_draft_persister.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'chats.dart';

class ChatMessageEditorCubit extends Bloc {
  final int? chatId;
  final int? userId;
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
    required this.userId,
    required this.senderUserId,
  }) :
      assert(
        (chatId != null && userId == null) ||
        (chatId == null && userId != null)
      )
  {
    _init();
  }

  void _init() async {
    final draft = await _getDraft();
    if (draft != null) {
      _fillWithDraft(draft);
    }

    _textEditingController.addListener(_onTextChanged);
    _pushOutput();
  }

  Future<ChatMessageDraft?> _getDraft() {
    if (chatId != null) {
      return _persister.getDraftByChatId(chatId!);
    }
    if (userId != null) {
      return _persister.getDraftByChatId(userId!);
    }
    throw Exception('chatId and userId are both null. Should never get here.');
  }

  void _fillWithDraft(ChatMessageDraft draft) {
    final body = draft.body;

    if (body is ContentMessageBody) {
      _textEditingController.text = body.text;
    }
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
    if (chatId != null) {
      _persister.deleteDraftByChatId(chatId!);
    }
    if (userId != null) {
      _persister.deleteDraftByUserId(userId!);
    }
  }

  void _saveDraft() {
    final draft = _createDraft();

    if (draft == null) {
      _deleteDraft();
    } else {
      _persister.saveDraft(draft);
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

  void onSendPressed() async {
    final draft = _createDraft();
    if (draft == null) return;

    final message = await _draftToSendingMessage(draft);
    _chatsCubit.send(message);
    _clear();
  }

  bool _isEmpty() {
    return _textEditingController.text.trim() == '';
  }

  ChatMessageDraft? _createDraft() {
    final text = _textEditingController.text.trim();
    if (text == '') return null;

    return ChatMessageDraft(
      recipientChatId:  chatId,
      recipientUserId:  userId,
      body: ContentMessageBody(
        text: text,
      ),
    );
  }

  Future<SendingChatMessage> _draftToSendingMessage(
    ChatMessageDraft draft,
  ) async {
    final chatId = (draft.recipientChatId == null)
      ? await _getChatId()
      : draft.recipientChatId!;

    return SendingChatMessage(
      senderUserId:     senderUserId,
      recipientChatId:  chatId,
      type:             ChatMessageTypeEnum.content,
      body:             draft.body,
      uuid:             _uuidGenerator.v4(),
      status:           SendingChatMessageStatus.readyToSend,
    );
  }

  Future<int> _getChatId() async {
    if (chatId != null) return chatId!;

    final chatRepository = GetIt.instance.get<ChatRepository>();
    final chat = await chatRepository.getOrCreateByUserId(userId!);

    _chatsCubit.onChatStarted(chat);
    _chatsCubit.chatListCubit.setCurrentChat(chat);
    return chat.id;
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
