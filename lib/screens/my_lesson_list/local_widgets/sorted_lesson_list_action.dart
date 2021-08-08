import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/models/done_popup/done_popup.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/screens/confirm/confirm.dart';
import 'package:courseplease/screens/my_lesson_list/local_blocs/lesson_list_action.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/list_action/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/widgets/list_action.dart';

class SortedLessonListActionWidget extends AbstractListActionWidget<
  int,
  Lesson,
  MyLessonFilter,
  MediaSortActionEnum,
  LessonListActionCubit
> {
  SortedLessonListActionWidget({
    required LessonListActionCubit listActionCubit,
    required SelectableListCubit<int, MyLessonFilter> selectableListCubit,
  }) : super(
    listActionCubit: listActionCubit,
    selectableListCubit: selectableListCubit,
  );

  @override
  Widget buildWithStates({
    required BuildContext context,
    required ListActionCubitState<MediaSortActionEnum> listActionCubitState,
    required SelectableListState<int, MyLessonFilter> selectableListState,
  }) {
    if (!selectableListState.selected) {
      return Text(tr('MyLessonListScreen.select'));
    }

    return Row(
      children: [
        ElevatedButtonWithProgress(
          child: Icon(Icons.delete),
          isLoading: listActionCubitState.actionInProgress == MediaSortActionEnum.delete,
          onPressed: () => _onUnlinkPressed(context, selectableListState),
        ),
      ],
    );
  }

  void _onUnlinkPressed(
    BuildContext context,
    SelectableListState<int, MyLessonFilter> selectableListState,
  ) async {
    final confirmed = await ConfirmScreen.show(
      context: context,
      content: Text(tr('MyLessonListScreen.confirmDelete')),
      okText: tr('MyLessonListScreen.delete'),
    );

    if (!confirmed) return;

    await listActionCubit.unlink(selectableListState);
    DonePopupScreen.show(context);
  }
}
