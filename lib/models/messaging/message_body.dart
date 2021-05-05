import 'package:courseplease/models/shop/delivery.dart';

abstract class MessageBody {
}

class UnknownMessageBody extends MessageBody {
}

/// Used both for received messages and for sending.
class ContentMessageBody extends MessageBody {
  final String text;

  ContentMessageBody({
    required this.text,
  });

  factory ContentMessageBody.fromMap(Map<String, dynamic> map) {
    return ContentMessageBody(
      text: map['text'],
    );
  }

  // Extract this if received and sending objects classes are split.
  // This is only required for sending.
  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

class PurchaseMessageBody extends MessageBody {
  final Delivery delivery;
  final double quantity;

  PurchaseMessageBody({
    required this.delivery,
    required this.quantity,
  });
}
