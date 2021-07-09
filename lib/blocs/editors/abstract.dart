import 'dart:async';

typedef VoidCallback = void Function();

abstract class AbstractValueEditorController<T> {
  final _changesController = StreamController<void>.broadcast();
  Stream<void> get changes => _changesController.stream;

  final _listeners = <VoidCallback>[];

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void fireChange() {
    _changesController.sink.add(null);

    for (final listener in _listeners) {
      listener();
    }
  }

  void setValue(T? value);
  T? getValue();

  void dispose() {
    _changesController.close();
  }
}
