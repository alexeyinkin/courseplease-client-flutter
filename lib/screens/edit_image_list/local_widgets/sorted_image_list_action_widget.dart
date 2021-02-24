import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/media_destination.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/widgets/list_action.dart';

class SortedImageListActionWidget extends ListActionWidget<
    int,
    ImageEntity,
    EditImageFilter,
    MediaSortActionEnum,
    ImageListActionCubit
> {
  SortedImageListActionWidget({
    @required ImageListActionCubit imageListActionCubit,
    @required SelectableListCubit<int, EditImageFilter> selectableListCubit,
  }) : super(
    listActionCubit: imageListActionCubit,
    selectableListCubit: selectableListCubit,
  );

  @override
  Widget buildWithStates({
    BuildContext context,
    ListActionCubitState<MediaSortActionEnum> listActionCubitState,
    SelectableListState<int, EditImageFilter> selectableListState,
  }) {
    if (!selectableListState.selected) {
      return Text("Select Images");
    }

    final withSelectedText = "With " + selectableListState.selectedIds.length.toString() + " Selected";

    return Row(
      children: [
        ElevatedButtonWithDropdownMenu<MediaSortActionEnum>(
          child: Text(withSelectedText),
          onSelected: (action) => _onActionSelected(context, action, selectableListState),
          isLoading: listActionCubitState.actionInProgress != null,
          items: [
            PopupMenuItem(
              child: Text("Move To..."),
              value: MediaSortActionEnum.move,
            ),
            PopupMenuItem(
              child: Text("Copy To..."),
              value: MediaSortActionEnum.link,
            ),
            // TODO: Implement archiving.
            // PopupMenuItem(
            //   child: Text("Archive"),
            //   value: _Action.archive,
            // ),
            PopupMenuItem(
              child: Text("Delete"),
              value: MediaSortActionEnum.unlink,
            ),
          ],
        ),
      ],
    );
  }

  void _onActionSelected(
    BuildContext context,
    MediaSortActionEnum action,
    SelectableListState selectableListState,
  ) {
    switch (action) {
      case MediaSortActionEnum.move: _onMoveSelected(context, selectableListState); break;
      case MediaSortActionEnum.link: _onLinkSelected(context, selectableListState); break;
      //case MediaSortActionEnum.archive: _onArchiveSelected(); break;
      case MediaSortActionEnum.unlink: _onUnlinkSelected(selectableListState); break;
    }
  }

  void _onMoveSelected(BuildContext context, SelectableListState selectableListState) async {
    final mediaDestinationCubit = MediaDestinationCubit();
    mediaDestinationCubit.outAction.listen(
      (mediaDestinationState) => _onMoveActionPressed(
        context,
        selectableListState,
        mediaDestinationState,
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => MediaDestinationDialog(
        listActionCubit: listActionCubit,
        mediaDestinationCubit: mediaDestinationCubit,
        selectableListState: selectableListState,
        action: MediaDestinationAction.move,
      ),
    );

    mediaDestinationCubit.dispose();
  }

  void _onMoveActionPressed(
    BuildContext context,
    SelectableListState selectableListState,
    MediaDestinationState mediaDestinationState,
  ) async {
    await listActionCubit.move(
      selectableListState,
      EditImageFilter(
        purposeIds: [mediaDestinationState.purposeId],
        subjectIds: [mediaDestinationState.subjectId],
      ),
    );
    _closeDialog(context);
    // TODO: Show a confirmation.
  }

  void _onLinkSelected(BuildContext context, SelectableListState selectableListState) async {
    final mediaDestinationCubit = MediaDestinationCubit();
    mediaDestinationCubit.outAction.listen(
      (mediaDestinationState) => _onLinkActionPressed(
        context,
        selectableListState.selectedIds.keys.toList(),
        mediaDestinationState,
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => MediaDestinationDialog(
        listActionCubit: listActionCubit,
        mediaDestinationCubit: mediaDestinationCubit,
        selectableListState: selectableListState,
        action: MediaDestinationAction.copy,
      ),
    );

    mediaDestinationCubit.dispose();
  }

  void _onLinkActionPressed(
    BuildContext context,
    List<int> ids,
    MediaDestinationState mediaDestinationState,
  ) async {
    await listActionCubit.link(
      ids,
      EditImageFilter(
        purposeIds: [mediaDestinationState.purposeId],
        subjectIds: [mediaDestinationState.subjectId],
      ),
    );
    _closeDialog(context);
    // TODO: Show a confirmation.
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _onArchiveSelected() {
    // TODO: Implement archiving.
  }

  void _onUnlinkSelected(SelectableListState selectableListState) async {
    await listActionCubit.unlink(selectableListState);
    // TODO: Show a confirmation.
  }
}
