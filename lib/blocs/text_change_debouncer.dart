import 'dart:async';

import 'package:courseplease/blocs/bloc.dart';
import 'package:flutter/widgets.dart';

class TextChangeDebouncer extends Bloc {
  final TextEditingController textEditingController;
  final VoidCallback onChanged;
  final Duration lag;

  Timer? _textEditingDebounce;

  TextChangeDebouncer({
    required this.textEditingController,
    required this.onChanged,
    this.lag = const Duration(milliseconds: 300),
  }) {
    textEditingController.addListener(_onChanged);
  }

  void _onChanged() {
    if (_textEditingDebounce?.isActive ?? false) _textEditingDebounce!.cancel();

    if (textEditingController.text == '') {
      onChanged();
      return;
    }

    _textEditingDebounce = Timer(lag, () {
      onChanged();
    });
  }

  @override
  void dispose() {
    if (_textEditingDebounce?.isActive ?? false) _textEditingDebounce!.cancel();
  }
}
