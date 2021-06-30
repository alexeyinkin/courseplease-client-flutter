import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/models/messaging/refund_request_message_body.dart';
import 'package:courseplease/screens/confirm/confirm.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/messaging/quote.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'date_push.dart';

class OthersRefundRequestMessageBodyWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final RefundRequestMessageBody body;

  OthersRefundRequestMessageBodyWidget({
    required this.message,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final localDeadline = body.deadline.toLocal();
    final locale = requireLocale(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('OthersRefundRequestMessageBodyWidget.beforeComplaint'),
          style: AppStyle.italic,
        ),
        SmallPadding(),
        QuoteWidget(child: Text(body.complaintText)),
        SmallPadding(),
        Text(
          tr(
            'OthersRefundRequestMessageBodyWidget.afterComplaint',
            namedArgs: {
              'date': formatDate(localDeadline, locale),
              'time': formatTime(localDeadline, locale),
            }
          ),
          style: AppStyle.italic,
        ),
        _getButtonsIfNeed(context),
        DatePushWidget(),
      ],
    );
  }

  Widget _getButtonsIfNeed(BuildContext context) {
    if (!body.canAct) return Container();

    return Column(
      children: [
        SmallPadding(),
        Wrap(
          spacing: 10,
          children: [
            ElevatedButton(
              child: Text(tr('OthersRefundRequestMessageBodyWidget.agree')),
              onPressed: () => _onAgreePressed(context),
            ),
            ElevatedButton(
              child: Text(tr('OthersRefundRequestMessageBodyWidget.insist')),
              onPressed: () => _onInsistPressed(context),
            ),
          ],
        ),
      ],
    );
  }

  void _onAgreePressed(BuildContext context) async {
     final confirmed = await ConfirmScreen.show(
       context: context,
       content: Text(tr('OthersRefundRequestMessageBodyWidget.agreePrompt')),
       okText: tr('OthersRefundRequestMessageBodyWidget.agree'),
     );
     if (!confirmed) return;

     final apiClient = GetIt.instance.get<ApiClient>();
     await apiClient.agreeToRefund(
       DeliveryRequest(deliveryId: body.deliveryId),
     );

     _reloadChat();
  }

  void _onInsistPressed(BuildContext context) async {
     final confirmed = await ConfirmScreen.show(
       context: context,
       content: Text(tr('OthersRefundRequestMessageBodyWidget.insistPrompt')),
       okText: tr('OthersRefundRequestMessageBodyWidget.insist'),
     );
     if (!confirmed) return;

     final apiClient = GetIt.instance.get<ApiClient>();
     await apiClient.insistToGetMoney(
       DeliveryRequest(deliveryId: body.deliveryId),
     );

     _reloadChat();
  }

  void _reloadChat() {
    final chatsCubit = GetIt.instance.get<ChatsCubit>();
    chatsCubit.refreshChatMessages(message.chatId);
  }
}
