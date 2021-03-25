import 'package:courseplease/blocs/chat_message_editor.dart';
import 'package:flutter/material.dart';
import '../small_circular_progress_indicator.dart';

class ChatMessageEditorWidget extends StatefulWidget {
  final int chatId;
  final int senderUserId;

  ChatMessageEditorWidget({
    required this.chatId,
    required this.senderUserId,
  }) : super(
    key: Key('chat-' + chatId.toString())
  );

  @override
  _ChatMessageEditorState createState() => _ChatMessageEditorState(
    chatId: chatId,
    senderUserId: senderUserId,
  );
}

class _ChatMessageEditorState extends State<ChatMessageEditorWidget> {
  final ChatMessageEditorCubit _chatMessageEditorCubit;

  _ChatMessageEditorState({
    required int chatId,
    required int senderUserId,
  }) :
      _chatMessageEditorCubit = ChatMessageEditorCubit(
        chatId: chatId,
        senderUserId: senderUserId,
      )
  ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChatMessageEditorState>(
      stream: _chatMessageEditorCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(ChatMessageEditorState? state) {
    if (state == null) return SmallCircularProgressIndicator();

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: state.textEditingController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ),
        TextButton(
          child: Icon(
            Icons.send,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onPressed: _chatMessageEditorCubit.onSendPressed,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chatMessageEditorCubit.dispose();
    super.dispose();
  }
}
