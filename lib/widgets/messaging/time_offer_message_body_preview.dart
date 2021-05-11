import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeOfferMessageBodyPreviewWidget extends StatelessWidget {
  final TimeOfferMessageBody body;

  TimeOfferMessageBodyPreviewWidget({
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        _getText(context),
        style: AppStyle.italic,
      ),
    );
  }

  String _getText(BuildContext context) {
    final dt = _getUnexpiredDateTime();

    return (dt == null)
        ? tr('TimeOfferMessageBodyPreviewWidget.expired')
        : _getUnexpiredText(context, dt);
  }

  DateTime? _getUnexpiredDateTime() {
    final now = DateTime.now();

    for (final dt in body.slots) {
      if (dt.isAfter(now)) return dt;
    }

    return null;
  }

  String _getUnexpiredText(BuildContext context, DateTime dt) {
    final locale = requireLocale(context);
    final keyTail = (body.slots.length > 1)
        ? 'multiple'
        : 'single';

    return tr(
      'TimeOfferMessageBodyPreviewWidget.text.' + keyTail,
      namedArgs: {
        'date': formatDetailedDate(dt, locale),
        'time': formatTime(dt, locale),
        'nMore': (body.slots.length - 1).toString(),
      },
    );
  }
}
