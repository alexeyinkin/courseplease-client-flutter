import 'package:courseplease/models/filters/chat.dart';
import 'package:courseplease/models/messaging/chat.dart';
import 'package:courseplease/models/messaging/chat_message.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/repositories/chat.dart';
import 'package:courseplease/screens/schedule/schedule.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/product_subject.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PurchaseMessageBodyWidget extends StatefulWidget {
  final ChatMessage message;
  final PurchaseMessageBody body;

  PurchaseMessageBodyWidget({
    required this.message,
    required this.body,
  });

  _PurchaseMessageBodyWidgetState createState() => _PurchaseMessageBodyWidgetState();
}

class _PurchaseMessageBodyWidgetState extends State<PurchaseMessageBodyWidget> {
  final _chatList = GetIt.instance.get<FilteredModelListCache>().getOrCreateNetworkList<int, Chat, ChatFilter, ChatRepository>(ChatFilter());

  @override
  Widget build(BuildContext context) {
    final actionWidgets = [
      ..._getDateWidgets(),
      ..._getScheduleButtons(),
      ..._getRefundButtons(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr('PurchaseMessageBodyWidget.purchased')),
        ProductSubjectWidget(
          id:                     widget.body.delivery.productSubjectId,
          translationKey:         'PurchaseMessageBodyWidget.oneHourLessonIn',
          translationPlaceholder: 'subject',
        ),
        Text(widget.body.delivery.productVariantFormatWithPrice.title),
        Flex(
          direction: Axis.horizontal,
          children: alternateWidgetListWith(actionWidgets, SmallPadding()),
        ),
        Text(''), // Date placeholder.
      ],
    );
  }

  List<Widget> _getDateWidgets() {
    final dateTimeStart = widget.body.delivery.dateTimeStart?.toLocal();
    if (dateTimeStart == null) return [];

    final locale = requireLocale(context);
    return [
      Text(
        tr(
          'common.dateTime',
          namedArgs: {
            'date': formatDetailedDate(dateTimeStart, locale),
            'time': formatTime(dateTimeStart, locale),
          },
        ),
      ),
    ];
  }

  List<Widget> _getScheduleButtons() {
    final dateTimeStart = widget.body.delivery.dateTimeStart;

    if (dateTimeStart != null) {
      final timeLeft = dateTimeStart.difference(DateTime.now());
      if (timeLeft.inSeconds < 0) return [];
    }

    final key = (dateTimeStart == null)
      ? 'PurchaseMessageBodyWidget.schedule'
      : 'PurchaseMessageBodyWidget.reschedule';

    return [
      ElevatedButton(
        child: Text(tr(key)),
        onPressed: _onSchedulePressed,
      ),
    ];
  }

  void _onSchedulePressed() {
    final chatId = widget.message.chatId;
    final chat = _chatList.getObject(chatId);
    final anotherUser = (chat != null && chat.otherUsers.length == 1)
        ? chat.otherUsers[0]
        : null;

    ScheduleScreen.show(
      context:      context,
      delivery:     widget.body.delivery,
      chatId:       chatId,
      anotherUser:  anotherUser,
    );
  }

  List<Widget> _getRefundButtons() {
    final dateTimeStart = widget.body.delivery.dateTimeStart;

    if (dateTimeStart != null) {
      final diff = DateTime.now().difference(dateTimeStart);
      if (diff.inDays < 1) return [];
    }

    return [
      ElevatedButton(
        child: Text(tr('PurchaseMessageBodyWidget.refund')),
       onPressed: _onRefundPressed,
      ),
    ];
  }

  void _onRefundPressed() {
    // TODO
  }
}
