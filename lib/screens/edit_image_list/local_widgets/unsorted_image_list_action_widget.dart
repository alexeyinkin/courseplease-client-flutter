import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/media_destination.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/widgets/list_action.dart';

class UnsortedImageListActionWidget extends ListActionWidget<
    int,
    ImageEntity,
    EditImageFilter,
    MediaSortActionEnum,
    ImageListActionCubit
> {
  UnsortedImageListActionWidget({
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
      return Text(tr('EditImageListScreen.selectImages'));
    }

    final withSelectedText = tr('EditImageListScreen.publishNSelected', namedArgs: {'n': selectableListState.selectedIds.length.toString()});

    return Row(
      children: [
        ElevatedButtonWithProgress(
          child: Row(
            children: [
              Text(withSelectedText),
              Icon(Icons.keyboard_arrow_down),
            ],
          ),
          isLoading: _isDropdownActionInProgress(listActionCubitState),
          onPressed: () => _showPublishDialog(context, selectableListState),
        ),
        SmallPadding(),
        ElevatedButtonWithProgress(
          child: Icon(Icons.delete),
          isLoading: listActionCubitState.actionInProgress == MediaSortActionEnum.delete,
          onPressed: () => _onUnlinkPressed(selectableListState),
        ),
      ],
    );
  }

  bool _isDropdownActionInProgress(ListActionCubitState<MediaSortActionEnum> state) {
    if (state.actionInProgress == null) return false;
    switch (state.actionInProgress) {
      case MediaSortActionEnum.delete:
        return false;
      default:
        return true;
    }
  }

  void _showPublishDialog(BuildContext context, SelectableListState selectableListState) async {
    MediaDestinationDialog.show<int, ImageEntity, EditImageFilter, EditorImageRepository>(
      context: context,
      selectableListState: selectableListState,
      listActionCubit: listActionCubit,
      onActionPressed: (mediaDestinationState) => _onMoveActionPressed(
        context,
        selectableListState,
        mediaDestinationState,
      ),
      action: MediaDestinationAction.publish,
    );
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

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _onUnlinkPressed(SelectableListState selectableListState) async {
    await listActionCubit.unlink(selectableListState);
    // TODO: Show a confirmation.
  }
}
