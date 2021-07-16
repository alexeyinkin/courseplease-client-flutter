import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class SendMessageButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool inProgress;

  SendMessageButton({
    required this.onPressed,
    this.inProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getProgressOverlayIfNeed(),
        TextButton(
          child: Icon(
            Icons.send,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }

  Widget _getProgressOverlayIfNeed() {
    if (!inProgress) return Container();

    return Positioned.fill(
      child: SmallCircularProgressIndicator(),
    );
  }
}
