import 'package:flutter/material.dart';

class SendMessageButton extends StatelessWidget {
  final VoidCallback onPressed;

  SendMessageButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Animate progress.
    return TextButton(
      child: Icon(
        Icons.send,
        color: Theme.of(context).textTheme.bodyText1!.color,
      ),
      onPressed: onPressed,
    );
  }
}
