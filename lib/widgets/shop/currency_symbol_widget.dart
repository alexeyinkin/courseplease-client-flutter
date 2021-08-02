import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class CurrencySymbolWidget extends StatelessWidget {
  final String cur;

  CurrencySymbolWidget({
    required this.cur,
  });

  @override
  Widget build(BuildContext context) {
    final translatedOrNot = tr('util.currencySymbols.' + cur);
    final text = translatedOrNot.split('.').last; // If not found, return just the cur.
    return Text(text);
  }
}
