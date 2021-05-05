import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/services/messaging/abstract.dart';

class PurchaseMessageBodyDenormalizer extends AbstractMessageBodyDenormalizer {
  @override
  MessageBody denormalize(int messageType, Map<String, dynamic> map) {
    return PurchaseMessageBody(
      delivery: Delivery.fromMap(map['delivery']),
      quantity: map['quantity'].toDouble(),
    );
  }
}
