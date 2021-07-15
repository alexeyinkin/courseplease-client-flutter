import 'package:courseplease/models/reaction/comment.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/teacher_builder.dart';
import 'package:courseplease/widgets/text_and_trailing.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:flutter/material.dart';

class CommentTile extends AbstractObjectTile<int, Comment, CommentFilter> {
  CommentTile({
    required TileCreationRequest<int, Comment, CommentFilter> request,
  }) : super(
    request: request,
  );

  @override
  _CommentTileState createState() => _CommentTileState();
}

class _CommentTileState extends AbstractObjectTileState<int, Comment, CommentFilter, CommentTile> {
  static const _inlineDateWidth = 50.0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        TeacherBuilderWidget(
          id: widget.object.authorId,
          builder: (context, user) => _buildUserpicAndName(user),
        ),
        Container(
          padding: EdgeInsets.only(top: UserpicAndNameWidget.picSize / 2 - 8),
          child: _getContent(context),
        ),
      ],
    );
  }

  Widget _buildUserpicAndName(User user) {
    return UserpicAndNameWidget(user: user, textStyle: AppStyle.bold);
  }

  Widget _getContent(BuildContext context) {
    final locale = requireLocale(context);

    return TextAndTrailingWidget(
      text: widget.object.text,
      trailing: Opacity(
        opacity: .5,
        child: Text(formatTimeOrDate(widget.object.dateTimeInsert, locale)),
      ),
      trailingWidth: _inlineDateWidth,
    );
  }
}
