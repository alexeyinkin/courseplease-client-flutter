import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/screens/my_lesson_list/local_blocs/lesson_list_action.dart';
import 'package:courseplease/screens/my_lesson_list/local_widgets/sorted_lesson_list_action.dart';
import 'package:courseplease/widgets/list_selection.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class SortedLessonListToolbar extends StatelessWidget {
  final LessonListActionCubit listActionCubit;
  final SelectableListCubit<int, MyLessonFilter> selectableListCubit;
  final VoidCallback onCreatePressed;

  SortedLessonListToolbar({
    required this.listActionCubit,
    required this.selectableListCubit,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListSelectionWidget(
          selectableListCubit: selectableListCubit,
        ),
        SmallPadding(),
        SortedLessonListActionWidget(
          listActionCubit: listActionCubit,
          selectableListCubit: selectableListCubit,
        ),
        Spacer(),
        ElevatedButton(
          child: Icon(Icons.add),
          onPressed: onCreatePressed,
        ),
        // TODO: Add a synchronization button when we can pull lessons from YouTube channels and playlists.
        // ConditionalSynchronizeProfilesButton(
        //   imageListActionCubit: listActionCubit,
        //   selectableListCubit: selectableListCubit,
        // ),
      ],
    );
  }
}
