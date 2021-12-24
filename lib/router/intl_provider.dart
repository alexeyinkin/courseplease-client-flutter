import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';

Future<Locale> getDeviceLocale() async {
  final localeString = await findSystemLocale();
  return localeString.toLocale();
}
