import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/media_destination.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/widgets/list_action.dart';

class SortedImageListActionWidget extends AbstractListActionWidget<
  int,
  ImageEntity,
  EditImageFilter,
  MediaSortActionEnum,
  ImageListActionCubit
> {
  SortedImageListActionWidget({
    required ImageListActionCubit imageListActionCubit,
    required SelectableListCubit<int, EditImageFilter> selectableListCubit,
  }) : super(
    listActionCubit: imageListActionCubit,
    selectableListCubit: selectableListCubit,
  );

  @override
  Widget buildWithStates({
    required BuildContext context,
    required ListActionCubitState<MediaSortActionEnum> listActionCubitState,
    required SelectableListState<int, EditImageFilter> selectableListState,
  }) {
    if (!selectableListState.selected) {
      return Text(tr('EditImageListScreen.selectImages'));
    }

    final withSelectedText = tr('EditImageListScreen.withNSelected', namedArgs: {'n': selectableListState.selectedIds.length.toString()});

    return Row(
      children: [
        ElevatedButtonWithDropdownMenu<MediaSortActionEnum>(
          child: Text(withSelectedText),
          onSelected: (action) => _onActionSelected(context, action, selectableListState),
          isLoading: listActionCubitState.actionInProgress != null,
          items: [
            PopupMenuItem(
              child: Text(tr('EditImageListScreen.actions.move')),
              value: MediaSortActionEnum.move,
            ),
            PopupMenuItem(
              child: Text(tr('EditImageListScreen.actions.copy')),
              value: MediaSortActionEnum.link,
            ),
            // TODO: Implement archiving.
            // PopupMenuItem(
            //   child: Text('Archive'),
            //   value: _Action.archive,
            // ),
            PopupMenuItem(
              child: Text(tr('EditImageListScreen.actions.delete')),
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
    SelectableListState<int, EditImageFilter> selectableListState,
  ) {
    switch (action) {
      case MediaSortActionEnum.move: _onMoveSelected(context, selectableListState); break;
      case MediaSortActionEnum.link: _onLinkSelected(context, selectableListState); break;
      //case MediaSortActionEnum.archive: _onArchiveSelected(); break;
      case MediaSortActionEnum.unlink: _onUnlinkSelected(selectableListState); break;
    }
  }

  void _onMoveSelected(
    BuildContext context,
    SelectableListState<int, EditImageFilter> selectableListState,
  ) async {
    MediaDestinationDialog.show<int, ImageEntity, EditImageFilter, EditorImageRepository>(
      context: context,
      selectableListState: selectableListState,
      listActionCubit: listActionCubit,
      onActionPressed: (mediaDestinationState) => _onMoveActionPressed(
        context,
        selectableListState,
        mediaDestinationState,
      ),
      action: MediaDestinationAction.move,
    );
  }

  void _onMoveActionPressed(
    BuildContext context,
    SelectableListState<int, EditImageFilter> selectableListState,
    MediaDestinationState mediaDestinationState,
  ) async {
    await listActionCubit.move(
      selectableListState,
      _mediaDestinationStateToSetFilter(mediaDestinationState),
    );
    _closeDialog(context);
    // TODO: Show a confirmation.
  }

  // TODO: Move to a common superclass with UnsortedImageListActionWidget
  EditImageFilter _mediaDestinationStateToSetFilter(MediaDestinationState state) {
    return EditImageFilter(
      purposeIds: state.purposeId == null ? [] : [state.purposeId!],
      subjectIds: state.subjectId == null ? [] : [state.subjectId!],
    );
  }

  void _onLinkSelected(
    BuildContext context,
    SelectableListState<int, EditImageFilter> selectableListState,
  ) async {
    MediaDestinationDialog.show<int, ImageEntity, EditImageFilter, EditorImageRepository>(
      context: context,
      selectableListState: selectableListState,
      listActionCubit: listActionCubit,
      onActionPressed: (mediaDestinationState) => _onLinkActionPressed(
        context,
        selectableListState.selectedIds.keys.toList(),
        mediaDestinationState,
      ),
      action: MediaDestinationAction.copy,
    );
  }

  void _onLinkActionPressed(
    BuildContext context,
    List<int> ids,
    MediaDestinationState mediaDestinationState,
  ) async {
    await listActionCubit.link(
      ids,
      _mediaDestinationStateToSetFilter(mediaDestinationState),
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

  void _onUnlinkSelected(
    SelectableListState<int, EditImageFilter> selectableListState,
  ) async {
    await listActionCubit.unlink(selectableListState);
    // TODO: Show a confirmation.
  }
}
