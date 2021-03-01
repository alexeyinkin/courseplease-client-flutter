import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/theme/theme.dart';
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
      children.add(
        TeacherSubjectProductVariantWidget(
          format: format,
          onPressed: () => _onFormatPressed(format),
          showButton: onPressed != null,
        ),
      );
    }

    return Column(
      children: children,
    );
  }

  void _onFormatPressed(ProductVariantFormatWithPrice format) {
    if (onPressed != null) {
      onPressed(format);
    }
  }
}

class TeacherSubjectProductVariantWidget extends StatelessWidget {
  final ProductVariantFormatWithPrice format;
  final VoidCallback onPressed;
  final bool showButton;

  TeacherSubjectProductVariantWidget({
    @required this.format,
    @required this.onPressed,
    @required this.showButton,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(format.title),
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
      trailing: _getPriceWidget(),
    );
  }

  Widget _getPriceWidget() {
    final moneyFormatted = format.maxPrice.formatPer('h');

    if (showButton) {
      return ElevatedButton(
        child: Text(moneyFormatted),
        onPressed: onPressed,
      );
    }

    return Text(moneyFormatted, style: AppStyle.h3);
  }
}
