import 'package:courseplease/blocs/list_action/list_action.dart';
import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:flutter/material.dart';

class SynchronizeProfileButton extends StatelessWidget {
  final ImageListActionCubit imageListActionCubit;
  final ListActionCubitState<MediaSortActionEnum> listActionCubitState;
  final int contactId;

  SynchronizeProfileButton({
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
