import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/models/done_popup/done_popup.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/media_destination.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/list_action/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/widgets/list_action.dart';

class UnsortedImageListActionWidget extends AbstractListActionWidget<
    int,
    ImageEntity,
    MyImageFilter,
    MediaSortActionEnum,
    ImageListActionCubit
> {
  UnsortedImageListActionWidget({
    required ImageListActionCubit imageListActionCubit,
    required SelectableListCubit<int, MyImageFilter> selectableListCubit,
  }) : super(
    listActionCubit: imageListActionCubit,
    selectableListCubit: selectableListCubit,
  );

  @override
  Widget buildWithStates({
    required BuildContext context,
    required ListActionCubitState<MediaSortActionEnum> listActionCubitState,
    required SelectableListState<int, MyImageFilter> selectableListState,
  }) {
    if (!selectableListState.selected) {
      return Text(tr('EditImageListScreen.select'));
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
          onPressed: () => _onUnlinkPressed(context, selectableListState),
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

  void _showPublishDialog(
    BuildContext context,
    SelectableListState<int, MyImageFilter> selectableListState,
  ) async {
    MediaDestinationDialog.show<int, ImageEntity, MyImageFilter, MyImageRepository>(
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
    SelectableListState<int, MyImageFilter> selectableListState,
    MediaDestinationState mediaDestinationState,
  ) async {
    await listActionCubit.move(
      selectableListState,
      _mediaDestinationStateToSetFilter(mediaDestinationState),
    );
    _closeDialog(context);
    DonePopupScreen.show(context);
  }

  // TODO: Move to a common superclass with SortedImageListActionWidget
  MyImageFilter _mediaDestinationStateToSetFilter(MediaDestinationState state) {
    return MyImageFilter(
      purposeIds: state.purposeId == null ? [] : [state.purposeId!],
      subjectIds: state.subjectId == null ? [] : [state.subjectId!],
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _onUnlinkPressed(
    BuildContext context,
    SelectableListState<int, MyImageFilter> selectableListState,
  ) async {
    await listActionCubit.unlink(selectableListState);
    DonePopupScreen.show(context);
  }
}
