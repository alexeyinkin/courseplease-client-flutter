import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/utils/utils.dart';

import 'time_slot.dart';

class TimeOfferMessageBody extends MessageBody {
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
}
