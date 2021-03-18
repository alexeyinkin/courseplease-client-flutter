import 'package:courseplease/utils/language.dart';
import 'package:flutter/widgets.dart';

import 'flag_icon.dart';

class LanguageWidget extends StatelessWidget {
  final String lang;

  LanguageWidget({
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(right: 7),
          child: FlagIcon(countryCode: langToCountryCode(lang)),
        ),
        Text(getLanguageName(lang) ?? lang),
      ],
    );
  }
}
