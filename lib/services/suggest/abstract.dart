import 'dart:async';

import 'package:model_interfaces/model_interfaces.dart';

typedef FutureOr<Iterable<T>> SuggestionsCallback<T>(String pattern); // As in flutter_typeahead

abstract class AbstractSuggestionService<T extends WithId> {
  Future<List<T>> suggest(String str);
}
