import 'package:courseplease/blocs/list_action/list_action.dart';
import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/synchronize_profile_button.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/synchronize_profiles_button.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/widgets/list_action.dart';

/// Shows a button to synchronize one or all profiles
/// if it is applicable to the current filter.
class ConditionalSynchronizeProfilesButton extends AbstractListActionWidget<
  int,
  ImageEntity,
  MyImageFilter,
  MediaSortActionEnum,
  ImageListActionCubit
> {
  ConditionalSynchronizeProfilesButton({
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
    if (selectableListState.filter.unsorted) {
      return SynchronizeProfilesButton(
        imageListActionCubit: listActionCubit,
        listActionCubitState: listActionCubitState,
      );
    }

    if (selectableListState.filter.contactIds.length == 1) {
      return SynchronizeProfileButton(
        imageListActionCubit: listActionCubit,
        listActionCubitState: listActionCubitState,
        contactId: selectableListState.filter.contactIds[0],
      );
    }

    return Container();
  }
}
