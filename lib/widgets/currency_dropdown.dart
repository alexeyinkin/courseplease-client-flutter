import 'package:easy_localization/easy_localization.dart';
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
        .map((value) => DropdownMenuItem<String>(value: value, child: Text(_getCurrencyTitle(value))))
        .toList();

    if (value != null && !values.contains(value)) {
      items.add(
        DropdownMenuItem<String>(value: value, child: Text(_getCurrencyTitle(value!))),
      );
    }

    return DropdownButton<String>(
      value: value,
      items: items,
      onChanged: (String? value) => onChanged(value!),
    );
  }

  String _getCurrencyTitle(String value) {
    final translated = tr('util.currencySymbols.' + value);
    return translated.split('.').last;
  }
}
