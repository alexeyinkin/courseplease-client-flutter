import 'package:courseplease/blocs/chat_message_editor.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final _focusNode = FocusNode();
  bool _showHint = true;

  _ChatMessageEditorState({
    required int chatId,
    required int senderUserId,
  }) :
      _chatMessageEditorCubit = ChatMessageEditorCubit(
        chatId: chatId,
        senderUserId: senderUserId,
      )
  {
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _showHint = !_focusNode.hasFocus;
    });
  }

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
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(10),
              hintText: _showHint ? tr('common.typeHere') : null,
            ),
            controller: state.textEditingController,
            focusNode: _focusNode,
            maxLines: 7,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            cursorColor: Theme.of(context).textTheme.bodyText1?.color,
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
    _focusNode.dispose();
    _chatMessageEditorCubit.dispose();
    super.dispose();
  }
}
