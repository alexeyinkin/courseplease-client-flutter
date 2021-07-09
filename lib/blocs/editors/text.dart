import 'package:flutter/widgets.dart';
import 'abstract.dart';

abstract class TextValueEditorController<T> extends AbstractValueEditorController<T> {
  final textEditingController = TextEditingController();

  void dispose() {
    textEditingController.dispose();
  }
}
