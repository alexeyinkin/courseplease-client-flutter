import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/models/messaging/refund_request_message_body.dart';
import 'package:courseplease/widgets/messaging/my_refund_request_message_body.dart';
import 'package:courseplease/widgets/messaging/others_refund_request_message_body.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RefundRequestMessageBodyWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final RefundRequestMessageBody body;

  RefundRequestMessageBodyWidget({
    required this.message,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = GetIt.instance.get<AuthenticationBloc>().currentState.data?.user;
    final my = currentUser?.id == message.senderUserId;

    return my
        ? MyRefundRequestMessageBodyWidget(body: body)
        : OthersRefundRequestMessageBodyWidget(message: message, body: body);
  }
}
