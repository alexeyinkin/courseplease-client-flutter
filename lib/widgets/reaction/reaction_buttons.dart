import 'package:courseplease/models/reaction/likable.dart';
import 'package:courseplease/models/reaction/commentable.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

import 'comment_count.dart';
import 'like_count.dart';

class ReactionButtons extends StatelessWidget {
  final Commentable? commentable;
  final VoidCallback? onCommentPressed;
  final Likable? likable;
  final String? catalog;
  final VoidCallback? reloadCallback;
  final bool isMy;

  ReactionButtons({
    this.commentable,
    this.onCommentPressed,
    this.likable,
    this.catalog,
    this.reloadCallback,
    required this.isMy,
  }) :
      assert((likable == null) == (catalog == null)),
      assert((likable == null) == (reloadCallback == null))
  ;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (commentable != null) children.add(_getCommentButton());
    if (likable != null) children.add(_getLikeButton());

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: alternateWidgetListWith(children, SmallPadding()),
    );
  }

  Widget _getCommentButton() {
    return CommentCountButton(
      commentable: commentable!,
      onPressed: onCommentPressed,
    );
  }

  Widget _getLikeButton() {
    return LikeCountButton(
      likable: likable!,
      catalog: catalog!,
      reloadCallback: reloadCallback!,
      canLike: !isMy,
    );
  }
}
