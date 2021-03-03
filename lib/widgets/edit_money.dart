import 'package:courseplease/models/money.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/currency_dropdown.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditMoneyWidget extends StatefulWidget {
  final Money money;
  final List<String> curs;

  EditMoneyWidget({
    @required this.money,
    @required this.curs,
  });

  @override
  _EditMoneyWidgetState createState() => _EditMoneyWidgetState();
}

class _EditMoneyWidgetState extends State<EditMoneyWidget> {
  TextEditingController _valueController; // Nullable
  String _cur; // Nullable

  @override
  void initState() {
    super.initState();

    _cur = widget.money.getFirstKey() ?? widget.curs[0];

    final double value = widget.money.map[_cur]; // Nullable
    final String valueString = (value == null || value == 0)
        ? ''
        : formatMoneyValue(value);

    _valueController = TextEditingController(text: valueString);
    _valueController.addListener(_onValueChanged);
  }

  @override
  Widget build(BuildContext context) {
    final unit = tr('util.units.h');
    final perH = tr('util.amountPerUnit', namedArgs: {'amount': '', 'unit': unit});
    return Row(
      children: [
        _getValueInput(),
        SmallHorizontalPadding(),
        _getCurrencyDropdown(),
        Text(perH),
      ],
    );
  }

  Widget _getValueInput() {
    return SizedBox(
      width: 80,
      child: TextFormField(
        controller: _valueController,
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _getCurrencyDropdown() {
    return CurrencyDropdownWidget(
      value: widget.money.getFirstKey(),
      values: widget.curs,
      onChanged: _onCurrencyChanged,
    );
  }

  void _onValueChanged() {
    _updateWidgetMoney();
  }

  double _parseValue() { // Nullable
    return double.tryParse(_valueController.text);
  }

  void _onCurrencyChanged(String cur) {
    _cur = cur;
    _updateWidgetMoney();
  }

  void _updateWidgetMoney() {
    final value = _parseValue();
    widget.money.replaceFrom(Money({_cur: value}));
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}
