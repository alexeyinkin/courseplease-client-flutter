import 'package:flutter/material.dart';

class TextAndTrailingWidget extends StatelessWidget {
  final String text;
  final Widget trailing;
  final double trailingWidth;

  TextAndTrailingWidget({
    required this.text,
    required this.trailing,
    required this.trailingWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _getTextWidget(context),
        Positioned(
          right: 0,
          bottom: 0,
          child: trailing,
        ),
      ],
    );
  }

  Widget _getTextWidget(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: DefaultTextStyle.of(context).style,
          ),
          _getInlineSpace(),
        ],
      ),
    );
  }

  InlineSpan _getInlineSpace() {
    return WidgetSpan(
      child: Container(
        width: trailingWidth,
      ),
    );
  }
}
