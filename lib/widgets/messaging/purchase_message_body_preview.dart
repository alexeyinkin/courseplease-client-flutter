import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/product_subjects_by_ids_builder.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PurchaseMessageBodyPreviewWidget extends StatelessWidget {
  final PurchaseMessageBody body;

  PurchaseMessageBodyPreviewWidget({
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ProductSubjectsByIdsBuilder(
      ids: [body.delivery.productSubjectId],
      builder: _buildWithProductSubjectOrNull
    );
  }

  Widget _buildWithProductSubjectOrNull(
    BuildContext context,
    ModelListByIdsState<int, ProductSubject>? list,
  ) {
    if (list == null || list.objects.isEmpty) {
      return SmallCircularProgressIndicator(scale: .5);
    }

    return _buildWithProductSubject(list.objects[0]);
  }

  Widget _buildWithProductSubject(ProductSubject ps) {
    return Container(
      child: Text(
        tr(
          'PurchaseMessageBodyPreviewWidget.text',
          namedArgs: {
            'subject': ps.title,
            'format': body.delivery.productVariantFormatWithPrice.title,
          },
        ),
        style: AppStyle.italic,
      ),
    );
  }
}
