import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TeacherSubjectProductVariantsWidget extends StatelessWidget {
  final TeacherSubject teacherSubject;
  final ValueChanged<ProductVariantFormatWithPrice> onPressed; // Nullable

  TeacherSubjectProductVariantsWidget({
    @required this.teacherSubject,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final format in teacherSubject.productVariantFormats) {
      if (!format.enabled) continue;

      children.add(
        TeacherSubjectProductVariantWidget(
          format: format,
          priceWidget: _getPriceWidget(format),
        ),
      );
    }

    return Column(
      children: children,
    );
  }

  Widget _getPriceWidget(ProductVariantFormatWithPrice format) {
    final moneyFormatted = format.maxPrice.formatPer('h');

    if (onPressed != null) {
      return ElevatedButton(
        child: Text(moneyFormatted),
        onPressed: () => _onFormatPressed(format),
      );
    }

    return Text(moneyFormatted, style: AppStyle.h3);
  }

  void _onFormatPressed(ProductVariantFormatWithPrice format) {
    if (onPressed != null) {
      onPressed(format);
    }
  }
}

class TeacherSubjectProductVariantWidget extends StatelessWidget {
  final ProductVariantFormatWithPrice format;
  final Widget priceWidget;

  TeacherSubjectProductVariantWidget({
    @required this.format,
    @required this.priceWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(tr('models.ProductVariantFormat.' + format.intName)),
          Container(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    style: BorderStyle.solid,
                    color: Color.lerp(Theme.of(context).textTheme.bodyText1.color, null, .6),
                  ),
                )
              ),
              child: Text(' '),
            ),
          ),
        ],
      ),
      trailing: priceWidget,
    );
  }
}
