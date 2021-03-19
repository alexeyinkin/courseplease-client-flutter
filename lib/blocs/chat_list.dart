import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:rxdart/rxdart.dart';

class ChatListCubit extends Bloc {
  final _outStateController = BehaviorSubject<ChatListCubitState>();
  Stream<ChatListCubitState> get outState => _outStateController.stream;

  final initialState = ChatListCubitState(
    currentChat: null,
    chatMessageFilter: null,
  );

  Chat? _currentChat;
  ChatMessageFilter? _chatMessageFilter;

  void setCurrentChat(Chat chat) {
    if (_currentChat == chat) return;
    _currentChat = chat;
    _chatMessageFilter = ChatMessageFilter(chatId: chat.id);
    _pushOutput();
  }

  void _pushOutput() {
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
