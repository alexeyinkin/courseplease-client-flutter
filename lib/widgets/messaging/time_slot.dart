import 'package:courseplease/blocs/chat_message_factory.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/chat_message_interface.dart';
import 'package:courseplease/models/messaging/time_approve_message_body.dart';
import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/models/messaging/time_slot.dart';
import 'package:courseplease/screens/message/message.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class TimeSlotWidget extends StatelessWidget {
  final ChatMessageInterface message;
  final TimeOfferMessageBody body;
  final TimeSlot slot;
  final bool my;

  TimeSlotWidget({
    required this.message,
    required this.body,
    required this.slot,
    required this.my,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _getOpacity(),
      child: ElevatedButton(
        onPressed: _isButtonEnabled(my) ? () => _onPressed(context, my) : null,
        child: _getTextWidget(context),
      ),
    );
  }

  double _getOpacity() {
    switch (slot.status) {
      case TimeSlotStatus.rejected:
      case TimeSlotStatus.recalled:
        return .3;
    }
    return 1;
  }

  bool _isButtonEnabled(bool my) {
    if (slot.isEnabled()) {
      return true; // Can confirm or toggle.
    }

    if (my) {
      switch (slot.status) {
        case TimeSlotStatus.recalled:
          return true;
      }
    }

    return false;
  }

  Widget _getTextWidget(BuildContext context) {
    final text = formatTime(slot.dateTime.toLocal(), requireLocale(context));

    switch (slot.status) {
      case TimeSlotStatus.confirmed:
        return Text(text, style: AppStyle.bold);
    }
    return Text(text);
  }

  void _onPressed(BuildContext context, bool my) {
    if (my) {
      _onPressedMy();
    } else {
      _onPressedAnothers(context);
    }
  }

  void _onPressedMy() {
    final _apiClient = GetIt.instance.get<ApiClient>();
    final request = TimeOfferMessageBody(
      deliveryId: body.deliveryId,
      slots: [
        TimeSlot(dateTime: slot.dateTime, status: _getToggledSlotStatus()),
      ],
    );

    _apiClient.updateTimeSlots(request);
  }

  String _getToggledSlotStatus() {
    switch (slot.status) {
      case TimeSlotStatus.recalled:
        return TimeSlotStatus.availableUntilExpire;
      case TimeSlotStatus.availableUntilExpire:
        return TimeSlotStatus.recalled;
    }
    throw Exception('Cannot toggle time slot status: ' + slot.status);
  }

  void _onPressedAnothers(BuildContext context) async {
    final dt = slot.dateTime.toLocal();
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
      deliveryId: (message.body as TimeOfferMessageBody).deliveryId,
      dateTime: slot.dateTime,
    );

    factory.send(
      chatId: message.chatId,
      type: ChatMessageTypeEnum.timeApprove,
      body: body,
    );
  }
}

enum ReserveResult {
  cancel,
  reserve,
}
