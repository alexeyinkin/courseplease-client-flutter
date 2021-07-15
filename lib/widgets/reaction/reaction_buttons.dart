import 'package:courseplease/models/reaction/commentable.dart';
import 'package:flutter/material.dart';

import 'comment_count.dart';

class ReactionButtons extends StatelessWidget {
  final Commentable commentable;
  final VoidCallback onCommentPressed;

  ReactionButtons({
    required this.commentable,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommentCountButton(
          commentable: commentable,
          onPressed: onCommentPressed,
        ),
      ],
    );
  }
}
