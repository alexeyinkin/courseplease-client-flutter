import 'dart:collection';

import 'package:courseplease/services/sse/abstract.dart';

class SseReloaderLocator {
  final _reloaders = <AbstractSseReloader>[];

  void add(AbstractSseReloader reloader) {
    _reloaders.add(reloader);
  }

  List<AbstractSseReloader> getAll() {
    return UnmodifiableListView<AbstractSseReloader>(_reloaders);
  }
}
