import 'package:courseplease/models/reaction/commentable.dart';
import 'package:courseplease/models/reaction/likable.dart';
import 'package:courseplease/widgets/builders/models/teacher.dart';
import 'package:courseplease/widgets/reaction/reaction_buttons.dart';
import 'package:courseplease/widgets/userpic_name_location.dart';
import 'package:flutter/widgets.dart';

class TeacherAndReactionsWidget extends StatelessWidget {
  final int teacherId;
  final Commentable? commentable;
  final VoidCallback? onCommentPressed;
  final Likable? likable;
  final String? catalog;
  final VoidCallback? reloadCallback;
  final bool isMy;

  TeacherAndReactionsWidget({
    required this.teacherId,
    this.commentable,
    this.onCommentPressed,
    this.likable,
    this.catalog,
    this.reloadCallback,
    required this.isMy,
  }) :
      assert((commentable == null) == (onCommentPressed == null)),
      assert((likable == null) == (catalog == null)),
      assert((likable == null) == (reloadCallback == null))
  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TeacherBuilderWidget(
              id: teacherId,
              builder: (context, teacher) => UserpicNameLocationWidget(teacher: teacher),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: ReactionButtons(
              commentable: commentable,
              onCommentPressed: onCommentPressed,
              likable: likable,
              catalog: catalog,
              reloadCallback: reloadCallback,
              isMy: isMy,
            ),
          ),
        ],
      ),
    );
  }
}
