import 'package:courseplease/widgets/app_flag.dart';
import 'package:flag/flag.dart';
import 'package:flutter/widgets.dart';

class FlagIcon extends StatelessWidget {
  final String countryCode;

  static const _w = 18.0;
  static const _h = 10.0;

  FlagIcon({
    required this.countryCode,
  });

  static const overriddenFlags = <String, void>{
    'arabic': true,
    'by': true,
  };

  @override
  Widget build(BuildContext context) {
    return overriddenFlags.containsKey(countryCode.toLowerCase())
        ? AppFlag(countryCode, height: _h, width: _w)
        : Flag(countryCode, height: _h, width: _w, replacement: Container(width: _w, height: _h));
  }
}
