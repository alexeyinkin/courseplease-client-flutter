import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/utils/utils.dart';

class TimeOfferMessageBody extends MessageBody {
  final int deliveryId;
  final List<DateTime> slots;

  TimeOfferMessageBody({
    required this.deliveryId,
    required this.slots,
  });

  factory TimeOfferMessageBody.fromMap(Map<String, dynamic> map) {
    final slots = dateTimesToLocal(
      stringsToDateTimes(
        map['slots'].cast<String>(),
      ),
    );

    return TimeOfferMessageBody(
      deliveryId: map['deliveryId'],
      slots:      slots,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryId': deliveryId,
      'slots':      dateTimesToStrings(slots),
    };
  }
}
