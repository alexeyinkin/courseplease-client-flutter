import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeOfferMessageBodyWidget extends StatefulWidget {
  final TimeOfferMessageBody body;

  TimeOfferMessageBodyWidget({
    required this.body,
  });

  @override
  _TimeOfferMessageBodyWidgetState createState() => _TimeOfferMessageBodyWidgetState();
}

class _TimeOfferMessageBodyWidgetState extends State<TimeOfferMessageBodyWidget> {
  @override
  Widget build(BuildContext context) {
    final groupedSlots = groupByDates(widget.body.slots);
    final children = <Widget>[];

    for (final dateTimes in groupedSlots) {
      children.add(
        _DateSlotsWidget(slots: dateTimes),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _DateSlotsWidget extends StatefulWidget {
  final List<DateTime> slots;

  _DateSlotsWidget({
    required this.slots,
  });

  @override
  _DateSlotsWidgetState createState() => _DateSlotsWidgetState();
}

class _DateSlotsWidgetState extends State<_DateSlotsWidget> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final dt in widget.slots) {
      children.add(
        _DateSlotWidget(slot: dt),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(
            'DateSlotsWidget.title',
            namedArgs: {
              'date': formatDetailedDate(widget.slots[0], requireLocale(context)),
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

class _DateSlotWidget extends StatefulWidget {
  final DateTime slot;

  _DateSlotWidget({
    required this.slot,
  });

  @override
  _DateSlotWidgetState createState() => _DateSlotWidgetState();
}

class _DateSlotWidgetState extends State<_DateSlotWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isEnabled() ? _onPressed : null,
      child: Text(
        formatTime(widget.slot, requireLocale(context)),
      ),
    );
  }

  bool _isEnabled() {
    return widget.slot.isAfter(DateTime.now());
  }

  void _onPressed() {
    // TODO
  }
}
