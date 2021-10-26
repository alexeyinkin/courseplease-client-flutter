import 'package:courseplease/blocs/like.dart';
import 'package:courseplease/models/reaction/likable.dart';
import 'package:courseplease/services/auth/sign_in_or_call.dart';
import 'package:courseplease/services/reaction/like_applier.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LikeCountButton extends StatelessWidget {
  final Likable likable;
  final String catalog;
  final bool canLike;
  final VoidCallback reloadCallback;
  final double scale;

  static const _iconSize = 24.0;
  final _likeCubit = GetIt.instance.get<LikeCubit>();

  LikeCountButton({
    required this.likable,
    required this.catalog,
    required this.canLike,
    required this.reloadCallback,
    this.scale = 1,
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
      child: GestureDetector(
        onTap: _onCreateLikePressed,
        child: Icon(
          Icons.favorite_outline,
          color: textColor,
          size: _getIconSize(),
        ),
      ),
    );
  }

  Widget _buildNonZeroLiked(Likable upToDateLikable, BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: _onDeleteLikePressed,
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: primaryColor,
            size: _getIconSize(),
          ),
          _getSpacing(),
          Text(
            upToDateLikable.likeCount.toString(),
            style: TextStyle(
              color: primaryColor,
              fontSize: AppStyle.reactionFontSize * scale,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonZeroNotLiked(Likable upToDateLikable, BuildContext context) {
    final textColor = getTextColor(context);

    return GestureDetector(
      onTap: _onCreateLikePressed,
      child: Row(
        children: [
          Icon(
            Icons.favorite_border,
            color: textColor,
            size: _getIconSize(),
          ),
          _getSpacing(),
          Text(
            upToDateLikable.likeCount.toString(),
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

  void _onCreateLikePressed() {
    if (!canLike) return;

    SignInOrCallService().callOrSignIn(
      SignInOrCallEvent(
        callback: _onCreateLikePressedAuthenticated,
      ),
    );
  }

  void _onCreateLikePressedAuthenticated() async {
    await _likeCubit.createLike(catalog, likable.id);
    reloadCallback();
  }

  void _onDeleteLikePressed() {
    SignInOrCallService().callOrSignIn(
      SignInOrCallEvent(
        callback: _onDeleteLikePressedAuthenticated,
      ),
    );
  }

  void _onDeleteLikePressedAuthenticated() async {
    await _likeCubit.deleteLike(catalog, likable.id);
    reloadCallback();
  }
}
