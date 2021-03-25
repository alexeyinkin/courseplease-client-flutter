import 'package:flutter/widgets.dart';

class PreparedMessageService {
  final _controllersByChatIds = <int, TextEditingController>{};

  TextEditingController getTextEditingController(int chatId) {
    if (!_controllersByChatIds.containsKey(chatId)) {
      _controllersByChatIds[chatId] = _createTextEditingController(chatId);
    }
    return _controllersByChatIds[chatId]!;
  }

  TextEditingController _createTextEditingController(int chatId) {
    final controller = TextEditingController();
    // TODO: Load stored content if any.
    // TODO: Add a listener.
    return controller;
  }
}
