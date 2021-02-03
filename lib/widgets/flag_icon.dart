import 'package:flag/flag.dart';
import 'package:flutter/widgets.dart';

class FlagIcon extends StatelessWidget {
  String countryCode;

  FlagIcon({
    @required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    return Flag(countryCode, height: 10, width: 18);
  }
}
