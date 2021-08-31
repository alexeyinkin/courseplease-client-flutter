import 'package:courseplease/blocs/editors/checkbox_group.dart';
import 'package:courseplease/models/product_variant_format.dart';
import 'package:courseplease/widgets/checkbox_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class TeachingFormatCheckboxGroupWidget extends StatelessWidget {
  final CheckboxGroupEditorController controller;

  TeachingFormatCheckboxGroupWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final labels = <String>[];

    for (final formatIntName in ProductVariantFormatIntNameEnum.allForFilter) {
      labels.add(tr('models.ProductVariantFormat.' + formatIntName));
    }

    return CheckboxGroupEditorWidget(
      controller: controller,
      allValues: ProductVariantFormatIntNameEnum.allForFilter,
      labels: labels,
    );
  }
}
