import 'package:courseplease/models/messaging/refund_request_message_body.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/messaging/quote.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'date_push.dart';

class MyRefundRequestMessageBodyWidget extends StatelessWidget {
  final RefundRequestMessageBody body;

  MyRefundRequestMessageBodyWidget({
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
          tr('MyRefundRequestMessageBodyWidget.beforeComplaint'),
          style: AppStyle.italic,
        ),
        SmallPadding(),
        QuoteWidget(child: Text(body.complaintText)),
        SmallPadding(),
        Text(
          tr(
            'MyRefundRequestMessageBodyWidget.afterComplaint',
            namedArgs: {
              'date': formatDate(localDeadline, locale),
              'time': formatTime(localDeadline, locale),
            }
          ),
          style: AppStyle.italic,
        ),
        DatePushWidget(),
      ],
    );
  }
}
