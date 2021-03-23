import 'package:courseplease/services/sse/abstract.dart';

class SseListenerLocator {
  final _listenersByType = <int, AbstractSseListener>{};

  void add(int type, AbstractSseListener listener) {
    _listenersByType[type] = listener;
  }

  AbstractSseListener? get(int type) {
    return _listenersByType[type];
  }
}
