import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:rxdart/rxdart.dart';

class ChatListCubit extends Bloc {
  /// This event is triggered when the current chat is changed.
  /// Listen to it to pop chat message lists up.
  final _outCurrentChatController = BehaviorSubject<Chat?>();
  Stream<Chat?> get outCurrentChat => _outCurrentChatController.stream;

  /// In the future this event will additionally be triggered
  /// when anything less important changes, like selection.
  /// For now it is doubles [outCurrentChat].
  final _outStateController = BehaviorSubject<ChatListCubitState>();
  Stream<ChatListCubitState> get outState => _outStateController.stream;

  final initialState = ChatListCubitState(
    currentChat: null,
    chatMessageFilter: null,
  );

  Chat? _currentChat;
  ChatMessageFilter? _chatMessageFilter;

  void setCurrentChat(Chat? chat) {
    if (_currentChat == chat) return;
    _currentChat = chat;
    _chatMessageFilter = chat == null ? null : ChatMessageFilter(chatId: chat.id);
    _pushCurrentChatOutput();
    _pushStateOutput();
  }

  void _pushCurrentChatOutput() {
    _outCurrentChatController.sink.add(_currentChat);
  }

  void _pushStateOutput() {
    final state = _createState();
    _outStateController.sink.add(state);
  }

  ChatListCubitState _createState() {
    return ChatListCubitState(
      currentChat: _currentChat,
      chatMessageFilter: _chatMessageFilter,
    );
  }

  @override
  void dispose() {
    _outStateController.close();
    _outCurrentChatController.close();
  }
}

class ChatListCubitState {
  final Chat? currentChat;
  final ChatMessageFilter? chatMessageFilter;

  ChatListCubitState({
    required this.currentChat,
    required this.chatMessageFilter,
  });
}
