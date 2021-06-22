import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/messaging/time_slot.dart';
import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/messaging/time_slots.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TimeOfferMessageBodyWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final TimeOfferMessageBody body;

  TimeOfferMessageBodyWidget({
    required this.message,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = GetIt.instance.get<AuthenticationBloc>().currentState.data?.user;
    final my = currentUser?.id == message.senderUserId;

    final groupedSlots = TimeSlot.groupByLocalDates(body.slots);
    final children = <Widget>[];

    for (final dateTimes in groupedSlots) {
      children.add(
        TimeSlotsWidget(
          message: message,
          body: body,
          slots: dateTimes,
          my: my,
        ),
      );
    }

    if (my) {
      if (isInFuture(body.slots.last.dateTime)) {
        children.add(
          Opacity(
            opacity: .5,
            child: Text(
              tr('TimeOfferMessageBodyWidget.tapToRecall'),
              style: AppStyle.minor,
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
