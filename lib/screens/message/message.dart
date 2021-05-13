import 'package:flutter/material.dart';

Future<T?> showMessageScreen<T>({
  required BuildContext context,
  required Widget title,
  Widget? child,
  required List<MessageScreenButton<T>> buttons
}) async
{
  final result = await showDialog<T>(
    context: context,
    builder: (context) => MessageScreen(
      title: title,
      content: child,
      buttons: buttons,
    ),
  );

  return result;
}

class MessageScreen<T> extends StatelessWidget {
  final Widget title;
  final Widget? content;
  final List<MessageScreenButton<T>> buttons;

  MessageScreen({
    required this.title,
    required this.content,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: _getButtons(context),
    );
  }

  List<Widget> _getButtons(BuildContext context) {
    final result = <Widget>[];

    for (final button in buttons) {
      result.add(
        ElevatedButton(
          onPressed: () => _onButtonPressed(context, button.value),
          child: Text(button.text),
        ),
      );
    }

    return result;
  }

  void _onButtonPressed(BuildContext context, T value) {
    Navigator.of(context).pop(value);
  }
}

class MessageScreenButton<T> {
  final String text;
  final T value;

  MessageScreenButton({
    required this.text,
    required this.value,
  });
}
