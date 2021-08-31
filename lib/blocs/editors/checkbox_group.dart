import 'package:courseplease/blocs/editors/abstract.dart';

class CheckboxGroupEditorController extends AbstractValueEditorController<List<String>> {
  final _values = <String, void>{};

  @override
  List<String> getValue() {
    return _values.keys.toList(growable: false);
  }

  @override
  void setValue(List<String>? values) {
    _values.clear();

    for (final value in values ?? []) {
      _values[value] = true;
    }

    fireChange();
  }

  void add(String value) {
    if (_values.containsKey(value)) return;
    _values[value] = true;
    fireChange();
  }

  void remove(String value) {
    if (!_values.containsKey(value)) return;
    _values.remove(value);
    fireChange();
  }

  void setSelected(String value, bool isSelected) {
    if (isSelected) {
      add(value);
    } else {
      remove(value);
    }
  }

  bool isSelected(String value) => _values.containsKey(value);
}
