import 'package:courseplease/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/widgets/list_action.dart';

/// Shows a button to synchronize one or all profiles
/// if it is applicable to the current filter.
class ConditionalSynchronizeProfilesButton extends AbstractListActionWidget<
  int,
  ImageEntity,
  EditImageFilter,
  MediaSortActionEnum,
  ImageListActionCubit
> {
  ConditionalSynchronizeProfilesButton({
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
    if (selectableListState.filter == null) return Container();

    if (selectableListState.filter.unsorted) {
      return _SynchronizeProfilesButton(
        imageListActionCubit: listActionCubit,
        listActionCubitState: listActionCubitState,
      );
    }

    if (selectableListState.filter.contactIds.length == 1) {
      return _SynchronizeProfileButton(
        imageListActionCubit: listActionCubit,
        listActionCubitState: listActionCubitState,
        contactId: selectableListState.filter.contactIds[0],
      );
    }

    return Container();
  }
}

class _SynchronizeProfilesButton extends StatelessWidget {
  final ImageListActionCubit imageListActionCubit;
  final ListActionCubitState<MediaSortActionEnum> listActionCubitState;

  _SynchronizeProfilesButton({
    required this.imageListActionCubit,
    required this.listActionCubitState,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWithProgress(
      child: Icon(Icons.sync),
      isLoading: listActionCubitState.actionInProgress == MediaSortActionEnum.synchronize,
      onPressed: _onPressed,
    );
  }

  void _onPressed() {
    imageListActionCubit.synchronizeProfiles();
  }
}

class _SynchronizeProfileButton extends StatelessWidget {
  final ImageListActionCubit imageListActionCubit;
  final ListActionCubitState<MediaSortActionEnum> listActionCubitState;
  final int contactId;

  _SynchronizeProfileButton({
    required this.imageListActionCubit,
    required this.listActionCubitState,
    required this.contactId,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonWithProgress(
      child: Icon(Icons.sync),
      isLoading: listActionCubitState.actionInProgress == MediaSortActionEnum.synchronize,
      onPressed: _onPressed,
    );
  }

  void _onPressed() {
    imageListActionCubit.synchronizeProfile(contactId);
  }
}
