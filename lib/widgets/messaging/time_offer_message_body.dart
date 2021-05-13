import 'package:courseplease/blocs/chat_message_factory.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/time_approve_message_body.dart';
import 'package:courseplease/models/messaging/time_slot.dart';
import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/screens/message/message.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TimeOfferMessageBodyWidget extends StatefulWidget {
  final ChatMessageInterface message;
  final TimeOfferMessageBody body;

  TimeOfferMessageBodyWidget({
    required this.message,
    required this.body,
  });

  @override
  _TimeOfferMessageBodyWidgetState createState() => _TimeOfferMessageBodyWidgetState();
}

class _TimeOfferMessageBodyWidgetState extends State<TimeOfferMessageBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final groupedSlots = TimeSlot.groupByLocalDates(widget.body.slots);
    final children = <Widget>[];

    for (final dateTimes in groupedSlots) {
      children.add(
        _DateSlotsWidget(
          message: widget.message,
          slots: dateTimes,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _DateSlotsWidget extends StatefulWidget {
  final ChatMessageInterface message;
  final List<TimeSlot> slots;

  _DateSlotsWidget({
    required this.message,
    required this.slots,
  });

  @override
  _TimeSlotsWidgetState createState() => _TimeSlotsWidgetState();
}

class _TimeSlotsWidgetState extends State<_DateSlotsWidget> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final slot in widget.slots) {
      children.add(
        _TimeSlotWidget(
          message: widget.message,
          slot: slot,
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
              'date': formatDetailedDate(widget.slots[0].dateTime, requireLocale(context)),
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

class _TimeSlotWidget extends StatefulWidget {
  final ChatMessageInterface message;
  final TimeSlot slot;

  _TimeSlotWidget({
    required this.message,
    required this.slot,
  });

  @override
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<_TimeSlotWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isEnabled() ? _onPressed : null,
      child: Text(
        formatTime(widget.slot.dateTime.toLocal(), requireLocale(context)),
      ),
    );
  }

  bool _isEnabled() {
    if (!widget.slot.enabled) return false;
    return widget.slot.dateTime.isAfter(DateTime.now());
  }

  void _onPressed() async {
    final dt = widget.slot.dateTime.toLocal();
    final locale = requireLocale(context);
    final result = await showMessageScreen<ReserveResult>(
      context: context,
      title: Text(
        tr(
          'TimeSlotWidget.message',
          namedArgs: {
            'date': formatDetailedDate(dt, locale),
            'time': formatTime(dt, locale),
          }
        ),
      ),
      buttons: [
        MessageScreenButton<ReserveResult>(
          text: tr('TimeSlotWidget.buttons.cancel'),
          value: ReserveResult.cancel,
        ),
        MessageScreenButton<ReserveResult>(
          text: tr('TimeSlotWidget.buttons.reserve'),
          value: ReserveResult.reserve,
        ),
      ],
    );

    if (result == ReserveResult.reserve) _reserve();
  }

  void _reserve() {
    final factory = GetIt.instance.get<ChatMessageFactory>();
    final body = TimeApproveMessageBody(
      deliveryId: (widget.message.body as TimeOfferMessageBody).deliveryId,
      dateTime: widget.slot.dateTime,
    );

    factory.send(
      chatId: widget.message.chatId,
      type: ChatMessageTypeEnum.timeApprove,
      body: body,
    );
  }
}

enum ReserveResult {
  cancel,
  reserve,
}
