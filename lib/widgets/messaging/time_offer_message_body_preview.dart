import 'package:courseplease/models/messaging/time_slot.dart';
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
    final slot = _getFirstEnabledSlot();

    return (slot == null)
        ? tr('TimeOfferMessageBodyPreviewWidget.expired')
        : _getUnexpiredText(context, slot);
  }

  TimeSlot? _getFirstEnabledSlot() {
    for (final slot in body.slots) {
      if (slot.isEnabled()) return slot;
    }

    return null;
  }

  String _getUnexpiredText(BuildContext context, TimeSlot slot) {
    final enabledSlots = body.getEnabledSlots();

    final locale = requireLocale(context);
    final keyTail = (enabledSlots.length > 1)
        ? 'multiple'
        : 'single';

    return tr(
      'TimeOfferMessageBodyPreviewWidget.text.' + keyTail,
      namedArgs: {
        'date': formatDetailedDate(slot.dateTime, locale),
        'time': formatTime(slot.dateTime, locale),
        'nMore': (enabledSlots.length - 1).toString(),
      },
    );
  }
}
