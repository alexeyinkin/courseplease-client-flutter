import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/shop/delivery_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LearningLessonsTabWidget extends StatefulWidget {
  @override
  _LearningLessonsTabWidgetState createState() => _LearningLessonsTabWidgetState();
}

class _LearningLessonsTabWidgetState extends State<LearningLessonsTabWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _getToScheduleList(),
        _getUpcomingList(),
        _getToApproveList(),
        _getResolvedList(),
      ],
    );
  }

  Widget _getToScheduleList() {
    return DeliveryListWidget(
      filter: DeliveryFilter(statusAlias: DeliveryStatusAlias.toSchedule),
      titleIfNotEmpty: Text(
        tr('LearningLessonsTabWidget.toSchedule'),
        style: AppStyle.h2,
      ),
    );
  }

  Widget _getUpcomingList() {
    return DeliveryListWidget(
      filter: DeliveryFilter(statusAlias: DeliveryStatusAlias.upcoming),
      titleIfNotEmpty: Text(
        tr('LearningLessonsTabWidget.upcoming'),
        style: AppStyle.h2,
      ),
    );
  }

  Widget _getToApproveList() {
    return DeliveryListWidget(
      filter: DeliveryFilter(statusAlias: DeliveryStatusAlias.toApprove),
      titleIfNotEmpty: Text(
        tr('LearningLessonsTabWidget.toApprove'),
        style: AppStyle.h2,
      ),
    );
  }

  Widget _getResolvedList() {
    return DeliveryListWidget(
      filter: DeliveryFilter(statusAlias: DeliveryStatusAlias.toSchedule),
      titleIfNotEmpty: Text(
        tr('LearningLessonsTabWidget.resolved'),
        style: AppStyle.h2,
      ),
    );
  }
}
