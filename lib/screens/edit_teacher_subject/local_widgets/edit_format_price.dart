import 'package:courseplease/models/product_variant_format_with_price.dart';
import 'package:courseplease/widgets/edit_money.dart';
import 'package:courseplease/widgets/teacher_subject_product_variants.dart';
import 'package:flutter/material.dart';

class EditFormatPriceWidget extends StatefulWidget {
  final ProductVariantFormatWithPrice productVariantFormatWithPrice; // Nullable
  final List<String> curs;

  EditFormatPriceWidget({
    @required this.productVariantFormatWithPrice,
    @required this.curs,
  });

  @override
  _EditFormatPriceWidgetState createState() => _EditFormatPriceWidgetState();
}

class _EditFormatPriceWidgetState extends State<EditFormatPriceWidget> {
  @override
  Widget build(BuildContext context) {
    return TeacherSubjectProductVariantWidget(
      format: widget.productVariantFormatWithPrice,
      priceWidget: SizedBox(
        width: 360,
        child: Row(
          children: [
            Switch(
              value: widget.productVariantFormatWithPrice.enabled,
              onChanged: _onEnabledChanged,
            ),
            Visibility(
              visible: widget.productVariantFormatWithPrice.enabled,
              child: EditMoneyWidget(
                money: widget.productVariantFormatWithPrice.maxPrice,
                curs: widget.curs,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onEnabledChanged(bool value) {
    setState(() {
      widget.productVariantFormatWithPrice.enabled = value;
    });
  }
}
