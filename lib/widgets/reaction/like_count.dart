import 'package:courseplease/blocs/like.dart';
import 'package:courseplease/models/reaction/likable.dart';
import 'package:courseplease/services/reaction/like_applier.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../pad.dart';

class LikeCountButton extends StatelessWidget {
  final Likable likable;
  final String catalog;
  final bool canLike;
  final VoidCallback reloadCallback;

  final _likeCubit = GetIt.instance.get<LikeCubit>();

  LikeCountButton({
    required this.likable,
    required this.catalog,
    required this.canLike,
    required this.reloadCallback,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LikeCubitState>(
      stream: _likeCubit.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? _likeCubit.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, LikeCubitState state) {
    final actions = state.getActionsFor(catalog, likable.id);
    final upToDateLikable = LikeApplierService().applyActions(likable, actions);

    if (upToDateLikable.likeCount <= 0) return _buildZero(context);

    return (upToDateLikable.isLiked)
        ? _buildNonZeroLiked(upToDateLikable, context)
        : _buildNonZeroNotLiked(upToDateLikable, context);
  }

  Widget _buildZero(BuildContext context) {
    final textColor = getTextColor(context);

    return Opacity(
      opacity: .3,
      child: TextButton(
        onPressed: _onCreateLikePressed,
        child: Icon(Icons.favorite_outline, color: textColor),
      ),
    );
  }

  Widget _buildNonZeroLiked(Likable upToDateLikable, BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return TextButton(
      onPressed: _onDeleteLikePressed,
      child: Row(
        children: [
          Icon(Icons.favorite, color: primaryColor),
          SmallPadding(),
          Text(
            upToDateLikable.likeCount.toString(),
            style: TextStyle(
              color: primaryColor,
              fontSize: AppStyle.reactionFontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonZeroNotLiked(Likable upToDateLikable, BuildContext context) {
    final textColor = getTextColor(context);

    return TextButton(
      onPressed: _onCreateLikePressed,
      child: Row(
        children: [
          Icon(Icons.favorite_border, color: textColor),
          SmallPadding(),
          Text(
            upToDateLikable.likeCount.toString(),
            style: TextStyle(
              color: textColor,
              fontSize: AppStyle.reactionFontSize,
            ),
          ),
        ],
      ),
    );
  }

  void _onCreateLikePressed() async {
    if (!canLike) return;
    await _likeCubit.createLike(catalog, likable.id);
    reloadCallback();
  }

  void _onDeleteLikePressed() async {
    await _likeCubit.deleteLike(catalog, likable.id);
    reloadCallback();
  }
}
