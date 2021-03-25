import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/messaging/sending_chat_message.dart';
import 'package:courseplease/services/prepared_message.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

class ChatMessageEditorWidget extends StatefulWidget {
  final int chatId;
  final int senderUserId;

  ChatMessageEditorWidget({
    required this.chatId,
    required this.senderUserId,
  });

  @override
  _ChatMessageEditorState createState() => _ChatMessageEditorState(
    chatId: chatId,
  );
}

class _ChatMessageEditorState extends State<ChatMessageEditorWidget> {
  final _chatsCubit = GetIt.instance.get<ChatsCubit>();
  final TextEditingController _textEditingController;
  final _uuidGenerator = Uuid();

  _ChatMessageEditorState({
    required int chatId,
  }) :
      _textEditingController = GetIt.instance.get<PreparedMessageService>().getTextEditingController(chatId)
  ;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _textEditingController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ),
        TextButton(
          child: Icon(
            Icons.send,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onPressed: _onSendPressed,
        ),
      ],
    );
  }

  void _onSendPressed() {
    final message = _createMessage();
    if (message == null) return;

    _chatsCubit.send(message);
    _clear();
  }

  SendingChatMessage? _createMessage() {
    final text = _textEditingController.text.trim();
    if (text == '') return null;

    return SendingChatMessage(
      senderUserId: widget.senderUserId,
      recipientChatId: widget.chatId,
      recipientUserId: null,
      body: MessageBody(
        text: text,
      ),
      uuid: _uuidGenerator.v4(),
      status: SendingChatMessageStatus.fresh,
    );
  }

  void _clear() {
    _textEditingController.text = '';
  }
}
