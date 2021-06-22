import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/services/net/api_client.dart';

import 'time_slot.dart';

class TimeOfferMessageBody extends MessageBody implements RequestBody {
  final int deliveryId;
  final List<TimeSlot> slots;

  TimeOfferMessageBody({
    required this.deliveryId,
    required this.slots,
  });

  factory TimeOfferMessageBody.fromMap(Map<String, dynamic> map) {
    return TimeOfferMessageBody(
      deliveryId: map['deliveryId'],
      slots:      TimeSlot.fromMaps(map['slots']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryId': deliveryId,
      'slots':      TimeSlot.toMaps(slots),
    };
  }

  List<TimeSlot> getEnabledSlots() {
    final result = <TimeSlot>[];

    for (final slot in slots) {
      if (slot.isEnabled()) result.add(slot);
    }

    return result;
  }
}
