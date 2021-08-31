import 'dart:convert';

import 'package:courseplease/services/shop/cached_map_currency_converter.dart';
import 'package:courseplease/services/shop/cbr_rate_parser.dart';
import 'package:flutter/services.dart' show rootBundle;

/// This class loads static hardcoded rates valid on 2021-08-31.
/// These are now only used as rough limits for price range filter
/// so no problem with outdating.
class CbrRateLoader {
  static Future<CachedMapCurrencyConverter> loadConverterFromAssets() async {
    final converter = CachedMapCurrencyConverter();
    await _fillConverterFromAssets(converter);
    return converter;
  }

  static Future<void> _fillConverterFromAssets(CachedMapCurrencyConverter converter) async {
    final parser = CbrRateParser();

    final dailyBytes = await rootBundle.load('assets/currency_rates/cbr_daily.xml');
    final dailyXml = utf8.decode(dailyBytes.buffer.asInt8List(), allowMalformed: true);
    final dailyMap = parser.parse(dailyXml);

    converter.addAll(dailyMap);
  }
}
