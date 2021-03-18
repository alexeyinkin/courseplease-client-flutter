import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TeacherSubjectProductVariantsWidget extends StatelessWidget {
  final TeacherSubject teacherSubject;
  final ValueChanged<ProductVariantFormatWithPrice>? onPressed;

  TeacherSubjectProductVariantsWidget({
    required this.teacherSubject,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final format in teacherSubject.productVariantFormats) {
      if (!format.enabled) continue;
      if (format.maxPrice == null) continue;

      children.add(
        TeacherSubjectProductVariantWidget(
          format: format,
          priceWidget: _getPriceWidget(format, format.maxPrice!),
        ),
      );
    }

    return Column(
      children: children,
    );
  }

  Widget _getPriceWidget(ProductVariantFormatWithPrice format, Money price) {
    final moneyFormatted = price.formatPer('h');

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
      onPressed!(format);
    }
  }
}

class TeacherSubjectProductVariantWidget extends StatelessWidget {
  final ProductVariantFormatWithPrice format;
  final Widget priceWidget;

  TeacherSubjectProductVariantWidget({
    required this.format,
    required this.priceWidget,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyText1?.color ?? AppStyle.errorColor;

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
                    color: Color.lerp(textColor, null, .6) ?? AppStyle.errorColor,
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
