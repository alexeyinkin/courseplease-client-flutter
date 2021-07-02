import 'package:courseplease/widgets/app_flag.dart';
import 'package:flag/flag.dart';
import 'package:flutter/widgets.dart';

class FlagIcon extends StatelessWidget {
  final String countryCode;

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
        ? AppFlag(countryCode, height: 10, width: 18)
        : Flag(countryCode, height: 10, width: 18);
  }
}
