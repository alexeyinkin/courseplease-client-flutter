import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/models/done_popup/done_popup.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/repositories/my_lesson.dart';
import 'package:courseplease/screens/my_lesson_list/local_blocs/lesson_list_action.dart';
import 'package:courseplease/widgets/media_destination.dart';
import 'package:courseplease/widgets/with_selected_button.dart';
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
    return WithSelectedButton<MediaSortActionEnum>(
      selectedCount: selectableListState.selectedIds.length,
      notSelectedPlaceholderText: tr('MyLessonListScreen.select'),
      menuItems: [
        PopupMenuItem(
          child: Text(tr('MyLessonListScreen.actions.move')),
          value: MediaSortActionEnum.move,
        ),
        PopupMenuItem(
          child: Text(tr('MyLessonListScreen.actions.delete')),
          value: MediaSortActionEnum.unlink,
        ),
      ],
      onSelected: (action) => _onActionSelected(context, action, selectableListState),
      isLoading: listActionCubitState.actionInProgress != null,
    );
  }

  void _onActionSelected(
    BuildContext context,
    MediaSortActionEnum action,
    SelectableListState<int, MyLessonFilter> selectableListState,
  ) {
    switch (action) {
      case MediaSortActionEnum.move: _onMoveSelected(context, selectableListState); break;
      case MediaSortActionEnum.link: _onLinkSelected(context, selectableListState); break;
      case MediaSortActionEnum.unlink: _onUnlinkSelected(context, selectableListState); break;
    }
  }

  void _onMoveSelected(
    BuildContext context,
    SelectableListState<int, MyLessonFilter> selectableListState,
  ) async {
    // MediaDestinationDialog.show<int, Lesson, MyLessonFilter, MyLessonRepository>(
    //   context: context,
    //   selectableListState: selectableListState,
    //   listActionCubit: listActionCubit,
    //   onActionPressed: (mediaDestinationState) => _onMoveActionPressed(
    //     context,
    //     selectableListState,
    //     mediaDestinationState,
    //   ),
    //   action: MediaDestinationAction.move,
    // );
  }

  // void _onMoveActionPressed(
  //   BuildContext context,
  //   SelectableListState<int, MyLessonFilter> selectableListState,
  //   MediaDestinationState mediaDestinationState,
  // ) async {
  //   await listActionCubit.move(
  //     selectableListState,
  //     _mediaDestinationStateToSetFilter(mediaDestinationState),
  //   );
  //   _closeDialog(context);
  //   DonePopupScreen.show(context);
  // }

  // // TODO: Move to a common superclass with UnsortedImageListActionWidget
  // MyImageFilter _mediaDestinationStateToSetFilter(MediaDestinationState state) {
  //   return MyImageFilter(
  //     purposeIds: state.purposeId == null ? [] : [state.purposeId!],
  //     subjectIds: state.subjectId == null ? [] : [state.subjectId!],
  //   );
  // }

  void _onLinkSelected(
    BuildContext context,
    SelectableListState<int, MyLessonFilter> selectableListState,
  ) async {
    // MediaDestinationDialog.show<int, ImageEntity, MyImageFilter, MyImageRepository>(
    //   context: context,
    //   selectableListState: selectableListState,
    //   listActionCubit: listActionCubit,
    //   onActionPressed: (mediaDestinationState) => _onLinkActionPressed(
    //     context,
    //     selectableListState.selectedIds.keys.toList(),
    //     mediaDestinationState,
    //   ),
    //   action: MediaDestinationAction.copy,
    // );
  }

  // void _onLinkActionPressed(
  //   BuildContext context,
  //   List<int> ids,
  //   MediaDestinationState mediaDestinationState,
  // ) async {
  //   await listActionCubit.link(
  //     ids,
  //     _mediaDestinationStateToSetFilter(mediaDestinationState),
  //   );
  //   _closeDialog(context);
  //   DonePopupScreen.show(context);
  // }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _onUnlinkSelected(
    BuildContext context,
    SelectableListState<int, MyLessonFilter> selectableListState,
  ) async {
    await listActionCubit.unlink(selectableListState);
    DonePopupScreen.show(context);
  }
}
