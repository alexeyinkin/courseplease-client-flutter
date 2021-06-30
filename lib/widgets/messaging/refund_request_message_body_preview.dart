import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/models/messaging/refund_request_message_body.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../pad.dart';

class RefundRequestMessageBodyPreviewWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final RefundRequestMessageBody body;

  RefundRequestMessageBodyPreviewWidget({
    required this.message,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = GetIt.instance.get<AuthenticationBloc>().currentState.data?.user;
    final my = currentUser?.id == message.senderUserId;

    return my
        ? _buildMine()
        : _buildNotMine(context);
  }

  Widget _buildMine() {
    return Text(
      tr('RefundRequestMessageBodyPreviewWidget.myText'),
      style: AppStyle.italic,
    );
  }

  Widget _buildNotMine(BuildContext context) {
    final locale = requireLocale(context);
    final localDeadline = body.deadline.toLocal();

    return Row(
      children: [
        Icon(
          Icons.error,
          color: AppStyle.errorColor,
        ),
        SmallPadding(),
        Expanded(
          child: Text(
            tr(
              'RefundRequestMessageBodyPreviewWidget.notMyText',
              namedArgs: {
                'date': formatDate(localDeadline, locale),
                'time': formatTime(localDeadline, locale),
              },
            ),
            style: AppStyle.italic,
          ),
        ),
      ],
    );
  }
}
