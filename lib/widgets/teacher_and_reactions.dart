import 'package:courseplease/models/reaction/commentable.dart';
import 'package:courseplease/widgets/builders/models/teacher.dart';
import 'package:courseplease/widgets/reaction/reaction_buttons.dart';
import 'package:courseplease/widgets/userpic_name_location.dart';
import 'package:flutter/widgets.dart';

class TeacherAndReactionsWidget extends StatelessWidget {
  final int teacherId;
  final Commentable commentable;
  final VoidCallback onCommentPressed;

  TeacherAndReactionsWidget({
    required this.teacherId,
    required this.commentable,
    required this.onCommentPressed,
  });

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
            ),
          ),
        ],
      ),
    );
  }
}
