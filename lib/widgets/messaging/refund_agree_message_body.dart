import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RefundAgreeMessageBodyWidget extends StatelessWidget {
  final ChatMessageInterface message;

  RefundAgreeMessageBodyWidget({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = GetIt.instance.get<AuthenticationBloc>().currentState.data?.user;
    final my = currentUser?.id == message.senderUserId;
    final keyTail = my ? 'myText' : 'othersText';

    return Text(
      tr('RefundAgreeMessageBodyWidget.' + keyTail),
      style: AppStyle.italic,
    );
  }
}
