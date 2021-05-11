import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class TimeOfferMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  TimeOfferMessageBody denormalize(int type, Map<String, dynamic> map) {
    return TimeOfferMessageBody.fromMap(map);
  }
}
