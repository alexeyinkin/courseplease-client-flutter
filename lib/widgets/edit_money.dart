import 'package:courseplease/models/money.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/currency_dropdown.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/shop/currency_symbol_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditMoneyWidget extends StatefulWidget {
  final Money money;
  final List<String> curs;
  final String? unit;
  final FocusNode? valueFocusNode;
  final TextEditingController valueController;

  EditMoneyWidget({
    required this.money,
    required this.curs,
    this.unit,
    this.valueFocusNode,
    required this.valueController,
  });

  @override
  _EditMoneyWidgetState createState() => _EditMoneyWidgetState();
}

class _EditMoneyWidgetState extends State<EditMoneyWidget> {
  String? _cur;

  @override
  void initState() {
    super.initState();

    _cur = widget.money.getFirstKey() ?? widget.curs[0];

    final double? value = widget.money.map[_cur];
    final String valueString = (value == null || value == 0)
        ? ''
        : formatMoneyValue(value);

    widget.valueController.text = valueString;
    widget.valueController.addListener(_onValueChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _getValueInput(),
        SmallPadding(),
        _getCurrencyWidget(),
        _getUnitWidgetIfNeed(),
      ],
    );
  }

  Widget _getValueInput() {
    return SizedBox(
      width: 80,
      child: AppTextField(
        controller: widget.valueController,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        focusNode: widget.valueFocusNode,
        onTap: _onValueInputTap,
      ),
    );
  }

  void _onValueInputTap() {
    widget.valueController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.valueController.text.length,
    );
  }

  Widget _getCurrencyWidget() {
    if (widget.curs.length == 1) {
      return CurrencySymbolWidget(cur: widget.curs[0]);
    }

    return CurrencyDropdownWidget(
      value: widget.money.getFirstKey() ?? widget.curs[0],
      values: widget.curs,
      onChanged: _onCurrencyChanged,
    );
  }

  void _onValueChanged() {
    _updateWidgetMoney();
  }

  Widget _getUnitWidgetIfNeed() {
    if (widget.unit == null) return Container();
    final unitString = tr('util.units.' + widget.unit!);
    final perUnitString = tr('util.amountPerUnit', namedArgs: {'amount': '', 'unit': unitString});
    return Text(perUnitString);
  }

  double? _parseValue() {
    return double.tryParse(widget.valueController.text);
  }

  void _onCurrencyChanged(String cur) {
    _cur = cur;
    _updateWidgetMoney();
  }

  void _updateWidgetMoney() {
    setState(() {
      final value = _parseValue();
      widget.money.replaceFrom(Money.fromNullableMap({_cur: value}));
    });
  }
}
