import 'package:courseplease/models/reaction/commentable.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';

class CommentCountButton extends StatelessWidget {
  final Commentable commentable;
  final VoidCallback? onPressed;
  final double scale;

  static const _iconSize = 24.0;

  CommentCountButton({
    required this.commentable,
    required this.onPressed,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return (commentable.commentCount > 0)
        ? _buildNonZero(context)
        : _buildZero(context);
  }

  Widget _buildZero(BuildContext context) {
    final textColor = getTextColor(context);

    return Opacity(
      opacity: .3,
      child: TextButton(
        onPressed: onPressed,
        child: Icon(
          Icons.mode_comment_outlined,
          color: textColor,
          size: _getIconSize(),
        ),
      ),
    );
  }

  Widget _buildNonZero(BuildContext context) {
    final textColor = getTextColor(context);

    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(
            Icons.mode_comment_outlined,
            color: textColor,
            size: _getIconSize(),
          ),
          _getSpacing(),
          Text(
            commentable.commentCount.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: AppStyle.reactionFontSize * scale,
            ),
          ),
        ],
      ),
    );
  }

  double _getIconSize() {
    return _iconSize * scale;
  }

  Widget _getSpacing() {
    return Container(width: 10 * scale);
  }
}
