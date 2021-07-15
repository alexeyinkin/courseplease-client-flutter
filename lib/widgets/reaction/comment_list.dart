import 'package:courseplease/models/reaction/comment.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/repositories/comment.dart';
import 'package:flutter/material.dart';

import '../abstract_object_tile.dart';
import '../pad.dart';
import 'be_first_to_comment.dart';
import 'comment_tile.dart';
import '../object_linear_list_view.dart';

class CommentListWidget extends StatelessWidget {
  final CommentFilter filter;
  final ScrollController? scrollController;

  CommentListWidget({
    required this.filter,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ObjectLinearListView<int, Comment, CommentFilter, CommentRepository, CommentTile>(
      filter: filter,
      tileFactory: _createTile,
      scrollDirection: Axis.vertical,
      scrollController: scrollController,
      emptyBuilder: (_) => BeFirstToCommentWidget(),
      separatorBuilder: (_) => SmallPadding(),

      // Ideally we want shrinkWrap here. But the http request hangs with it.
      //shrinkWrap: true,
    );
  }

  CommentTile _createTile(
    TileCreationRequest<int, Comment, CommentFilter> request,
  ) {
    return CommentTile(
      request: request,
    );
  }
}
