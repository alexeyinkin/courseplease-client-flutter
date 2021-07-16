import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/reaction/comment.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/screens/confirm/confirm.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/reload/comment.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/teacher_builder.dart';
import 'package:courseplease/widgets/text_and_trailing.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../pad.dart';

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
  static const _inlineDateWidth = 80.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _onTapUp,
      child: Wrap(
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
      ),
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
        child: Text(formatTimeOrDate(widget.object.dateTimeInsert.toLocal(), locale)),
      ),
      trailingWidth: _inlineDateWidth,
    );
  }

  void _onTapUp(TapUpDetails details) {
    final authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
    if (authenticationCubit.currentState.data?.user?.id == widget.object.authorId) {
      _showMyCommentMenu(details.globalPosition);
    }
  }

  void _showMyCommentMenu(Offset globalPosition) async {
    final items = [
      PopupMenuItem<CommentAction>(
        child: Text(tr('CommentTile.actions.delete')),
        value: CommentAction.delete,
      ),
    ];

    final screenSize = MediaQuery.of(context).size;
    final action = await showMenu<CommentAction>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx - 40,
        globalPosition.dy - 20,
        screenSize.width - globalPosition.dx,
        screenSize.height - globalPosition.dy,
      ),
      items: items,
    );

    switch (action) {
      case CommentAction.delete:
        _onDeletePressed();
        break;
      case null:
        break;
    }
  }

  void _onDeletePressed() async {
    final confirmed = await ConfirmScreen.show(
      context: context,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(tr('CommentTile.deletePrompt')),
          SmallPadding(),
          Text(
            widget.object.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.italic,
          ),
        ],
      ),
      okText: tr('CommentTile.actions.delete'),
    );
    if (!confirmed) return;

    _delete();
  }

  void _delete() async {
    final apiClient = GetIt.instance.get<ApiClient>();
    final request = DeleteCommentRequest(
      catalog: widget.filter.catalog,
      commentId: widget.object.id,
    );

    await apiClient.deleteComment(request);
    CommentReloadService().delete(widget.object.id);
  }
}

enum CommentAction {
  delete,
}
