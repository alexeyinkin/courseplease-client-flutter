import 'package:courseplease/models/language.dart';
import 'package:courseplease/repositories/abstract.dart';

class LanguageRepository extends AbstractRepository<String, Language> {
  final map = <String, Language>{
    'en': Language(id: 'en', title: 'English'),
    'cn': Language(id: 'cn', title: 'Chinese'),
    'hi': Language(id: 'hi', title: 'Hindi'),
    'es': Language(id: 'es', title: 'Spanish'),
    'ar': Language(id: 'ar', title: 'Arabic'),
    'fr': Language(id: 'fr', title: 'French'),
    'ms': Language(id: 'ms', title: 'Malay'),
    'ru': Language(id: 'ru', title: 'Russian'),

    'by': Language(id: 'by', title: 'Belarusian'),
  };

  @override
  Future<List<Language>> loadAll() {
    return Future.value(map.values.toList(growable: false));
  }

  @override
  Future<Language?> loadById(String id) {
    return Future.value(map[id]);
  }

  @override
  Future<List<Language>> loadByIds(List<String> ids) {
    final result = <Language>[];

    for (final id in ids) {
      final language = map[id];
      if (language == null) continue;
      result.add(language);
    }

    return Future.value(result);
  }
}
