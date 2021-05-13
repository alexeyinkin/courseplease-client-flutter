import 'package:courseplease/models/messaging/time_approve_message_body.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeApproveMessageBodyWidget extends StatelessWidget {
  final TimeApproveMessageBody body;

  TimeApproveMessageBodyWidget({
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final locale = requireLocale(context);
    final dateTime = body.dateTime.toLocal();

    return Row(
      children: [
        Icon(Icons.check_circle),
        SmallPadding(),
        Expanded(
          child: Text(
            tr(
              'TimeApproveMessageBodyWidget.text',
              namedArgs: {
                'date': formatDetailedDate(dateTime, locale),
                'time': formatTime(dateTime, locale),
                'timezone': getTimeZoneString(dateTime),
              },
            ),
            style: AppStyle.italic,
          ),
        ),
      ],
    );
  }
}
