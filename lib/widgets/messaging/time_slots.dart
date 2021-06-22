import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/models/messaging/time_slot.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/messaging/time_slot.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../pad.dart';

class TimeSlotsWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final TimeOfferMessageBody body;
  final List<TimeSlot> slots;
  final bool my;

  TimeSlotsWidget({
    required this.message,
    required this.body,
    required this.slots,
    required this.my,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final slot in slots) {
      children.add(
        TimeSlotWidget(
          message: message,
          body: body,
          slot: slot,
          my: my,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(
            'TimeSlotsWidget.title',
            namedArgs: {
              'date': formatDetailedDate(slots[0].dateTime, requireLocale(context)),
            },
          ),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: alternateWidgetListWith(children, SmallPadding()),
        ),
      ],
    );
  }
}

