import 'package:courseplease/blocs/pages.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/screens/image_pages/bloc.dart';
import 'package:courseplease/screens/image_pages/local_widgets/previous_image_overlay.dart';
import 'package:flutter/widgets.dart';

import 'image_reaction_overlay.dart';
import 'image_teacher_overlay.dart';
import 'image_title_overlay.dart';
import 'next_image_overlay.dart';

class ImageOverlaysWidget extends StatelessWidget {
  final ImagePagesBloc bloc;
  final PagesBlocItem<ImageEntity> item;
  final bool showAuthor;
  final bool showReactions;
  final VoidCallback? onCommentPressed;

  ImageOverlaysWidget({
    required this.bloc,
    required this.item,
    this.showAuthor = false,
    this.showReactions = false,
    this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ImagePagesBlocState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(ImagePagesBlocState state) {
    final children = <Widget>[
      ImageTitleOverlay(image: item.object, visible: state.controlsVisible),
      if (showAuthor) ImageTeacherOverlay(
        teacherId: item.object.authorId,
        visible: state.controlsVisible,
      ),
      if (showReactions) ImageReactionOverlay(
        image: item.object,
        visible: state.controlsVisible,
        onCommentPressed: onCommentPressed,
      ),
    ];

    if (!item.isFirst) {
      children.add(
        PreviousImageOverlay(
          visible: state.controlsVisible,
          onPressed: bloc.pagesBloc.previousPage,
        ),
      );
    }

    if (!item.isLast) {
      children.add(
        NextImageOverlay(
          visible: state.controlsVisible,
          onPressed: bloc.pagesBloc.nextPage,
        ),
      );
    }

    return Stack(
      children: children,
    );
  }
}
