import 'package:courseplease/models/product_variant_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:model_editors/model_editors.dart';

class TeachingFormatCheckboxGroupWidget extends StatelessWidget {
  final CheckboxGroupEditingController<String> controller;

  TeachingFormatCheckboxGroupWidget({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final labels = <String, String>{};

    for (final formatIntName in ProductVariantFormatIntNameEnum.allForFilter) {
      labels[formatIntName] = tr('models.ProductVariantFormat.' + formatIntName);
    }

    return MaterialCheckboxColumn(
      controller: controller,
      allValues: ProductVariantFormatIntNameEnum.allForFilter,
      labels: labels,
    );
  }
}
