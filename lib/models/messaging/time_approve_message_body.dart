import 'package:courseplease/models/messaging/message_body.dart';

class TimeApproveMessageBody extends MessageBody {
  final int deliveryId;
  final DateTime dateTime;

  TimeApproveMessageBody({
    required this.deliveryId,
    required this.dateTime,
  });

  factory TimeApproveMessageBody.fromMap(Map<String, dynamic> map) {
    return TimeApproveMessageBody(
      deliveryId: map['deliveryId'],
      dateTime:   DateTime.parse(map['dateTime']).toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryId': deliveryId,
      'dateTime':   dateTime.toUtc().toIso8601String(),
    };
  }
}
