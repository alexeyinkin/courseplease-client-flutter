import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/chat_message.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:rxdart/rxdart.dart';

class ChatsCubit extends Bloc {
  final _outStateController = BehaviorSubject<ChatsCubitState>();
  Stream<ChatsCubitState> get outState => _outStateController.stream;

  final initialState = ChatsCubitState(
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

  ChatsCubitState _createState() {
    return ChatsCubitState(
      currentChat: _currentChat,
      chatMessageFilter: _chatMessageFilter,
    );
  }

  @override
  void dispose() {
    _outStateController.close();
  }
}

class ChatsCubitState {
  final Chat? currentChat;
  final ChatMessageFilter? chatMessageFilter;

  ChatsCubitState({
    required this.currentChat,
    required this.chatMessageFilter,
  });
}
