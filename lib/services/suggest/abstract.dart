import 'dart:async';

import 'package:courseplease/models/interfaces.dart';

typedef FutureOr<Iterable<T>> SuggestionsCallback<T>(String pattern); // As in flutter_typeahead

abstract class AbstractSuggestionService<T extends WithId> {
  Future<List<T>> suggest(String str);
}
