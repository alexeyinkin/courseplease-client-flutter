import 'package:courseplease/router/lang_path.dart';

class LangPathParser {
  final _regExp = RegExp('/([a-z]{2})(/.*)?');

  final _excludeLangs = {
    'me': null,
  };

  LangPath parse(String path) {
    final match = _regExp.firstMatch(path);
    if (match == null) return LangPath(null, path);

    final lang = match[1];
    if (_excludeLangs.containsKey(lang)) return LangPath(null, path);

    return LangPath(lang, match[2] ?? '/');
  }
}
