import 'package:courseplease/blocs/editors/text.dart';
import 'package:model_interfaces/model_interfaces.dart';

class WithIdTitleEditorController<I, O extends WithIdTitle<I>> extends TextValueEditorController<O> {
  O? _value;

  @override
  void setValue(O? value) {
    _value = value;
    textEditingController.text = value?.title ?? '';
    super.fireChange();
  }

  @override
  O? getValue() => _value;
}
