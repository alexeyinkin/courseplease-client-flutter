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
  FocusNode _valueFocusNode;
  final _valueTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _valueFocusNode = FocusNode();
  }

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
                valueFocusNode: _valueFocusNode,
                valueTextEditingController: _valueTextEditingController,
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
      if (value) {
        _valueFocusNode.requestFocus();

        // TODO: Fix this. For some reason selecting all here not works now.
        _valueTextEditingController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _valueTextEditingController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _valueTextEditingController.dispose();
    _valueFocusNode.dispose();
    super.dispose();
  }
}
