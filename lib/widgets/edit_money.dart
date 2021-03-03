import 'package:courseplease/models/money.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/currency_dropdown.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EditMoneyWidget extends StatefulWidget {
  final Money money;
  final List<String> curs;
  final FocusNode valueFocusNode; // Nullable
  final TextEditingController valueTextEditingController; // Nullable

  EditMoneyWidget({
    @required this.money,
    @required this.curs,
    this.valueFocusNode,
    this.valueTextEditingController,
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

    if (widget.valueTextEditingController == null) {
      _valueController = TextEditingController();
    }

    final valueController = _getValueTextEditingController();
    valueController.text = valueString;
    valueController.addListener(_onValueChanged);
  }

  TextEditingController _getValueTextEditingController() {
    return widget.valueTextEditingController ?? _valueController;
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
        controller: _getValueTextEditingController(),
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        focusNode: widget.valueFocusNode,
        onTap: _onValueInputTap,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        )
      ),
    );
  }

  void _onValueInputTap() {
    final controller = _getValueTextEditingController();
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }

  Widget _getCurrencyDropdown() {
    return CurrencyDropdownWidget(
      value: widget.money.getFirstKey() ?? widget.curs[0],
      values: widget.curs,
      onChanged: _onCurrencyChanged,
    );
  }

  void _onValueChanged() {
    _updateWidgetMoney();
  }

  double _parseValue() { // Nullable
    return double.tryParse(_getValueTextEditingController().text);
  }

  void _onCurrencyChanged(String cur) {
    _cur = cur;
    _updateWidgetMoney();
  }

  void _updateWidgetMoney() {
    setState(() {
      final value = _parseValue();
      widget.money.replaceFrom(Money({_cur: value}));
    });
  }

  @override
  void dispose() {
    if (_valueController != null) {
      _valueController.dispose();
    }
    super.dispose();
  }
}
