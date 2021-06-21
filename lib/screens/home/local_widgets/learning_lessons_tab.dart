import 'package:courseplease/models/filters/delivery.dart';
import 'package:courseplease/models/product_variant_format.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/shop/delivery_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return _getDeliveryListWidget(
      filter: DeliveryFilter(
        statusAlias: DeliveryStatusAlias.toSchedule,
        productVariantFormatIntName: ProductVariantFormatIntNameEnum.consulting,
      ),
      titleText: tr('LearningLessonsTabWidget.toSchedule'),
    );
  }

  Widget _getUpcomingList() {
    return _getDeliveryListWidget(
      filter: DeliveryFilter(
        statusAlias: DeliveryStatusAlias.upcoming,
        productVariantFormatIntName: ProductVariantFormatIntNameEnum.consulting,
      ),
      titleText: tr('LearningLessonsTabWidget.upcoming'),
    );
  }

  Widget _getToApproveList() {
    return _getDeliveryListWidget(
      filter: DeliveryFilter(
        statusAlias: DeliveryStatusAlias.toApprove,
        productVariantFormatIntName: ProductVariantFormatIntNameEnum.consulting,
      ),
      titleText: tr('LearningLessonsTabWidget.toApprove'),
    );
  }

  Widget _getResolvedList() {
    return _getDeliveryListWidget(
      filter: DeliveryFilter(
        statusAlias: DeliveryStatusAlias.toSchedule,
        productVariantFormatIntName: ProductVariantFormatIntNameEnum.consulting,
      ),
      titleText: tr('LearningLessonsTabWidget.resolved'),
    );
  }

  Widget _getDeliveryListWidget({
    required DeliveryFilter filter,
    required String titleText,
  }) {
    return DeliveryListWidget(
      filter: filter,
      titleIfNotEmpty: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Text(
          titleText,
          style: AppStyle.h2,
        ),
      ),
    );
  }
}
