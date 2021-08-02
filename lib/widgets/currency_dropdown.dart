import 'package:courseplease/widgets/shop/currency_symbol_widget.dart';
import 'package:flutter/material.dart';

class CurrencyDropdownWidget extends StatelessWidget {
  final String? value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  CurrencyDropdownWidget({
    required this.value,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final items = values
        .map((value) => DropdownMenuItem<String>(value: value, child: CurrencySymbolWidget(cur: value)))
        .toList();

    if (value != null && !values.contains(value)) {
      items.add(
        DropdownMenuItem<String>(value: value, child: CurrencySymbolWidget(cur: value!)),
      );
    }

    return DropdownButton<String>(
      value: value,
      items: items,
      onChanged: (String? value) => onChanged(value!),
    );
  }
}
