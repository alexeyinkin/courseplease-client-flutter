import 'package:courseplease/models/messaging/message_body.dart';

class RefundRequestMessageBody extends MessageBody {
  final int deliveryId;
  final DateTime deadline;
  final bool canAct;
  final String complaintText;

  RefundRequestMessageBody({
    required this.deliveryId,
    required this.deadline,
    required this.canAct,
    required this.complaintText,
  });

  factory RefundRequestMessageBody.fromMap(Map<String, dynamic> map) {
    return RefundRequestMessageBody(
      deliveryId: map['deliveryId'],
      deadline: DateTime.parse(map['deadline']),
      canAct: map['canAct'],
      complaintText: map['complaintText'],
    );
  }
}
