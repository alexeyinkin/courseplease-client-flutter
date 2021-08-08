import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/conditional_synchronize_profiles_button.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/unsorted_image_list_action.dart';
import 'package:courseplease/widgets/list_selection.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class UnsortedImageListToolbar extends StatelessWidget {
  final ImageListActionCubit imageListActionCubit;
  final SelectableListCubit<int, MyImageFilter> selectableListCubit;

  UnsortedImageListToolbar({
    required this.imageListActionCubit,
    required this.selectableListCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListSelectionWidget(
          selectableListCubit: selectableListCubit,
        ),
        SmallPadding(),
        UnsortedImageListActionWidget(
          imageListActionCubit: imageListActionCubit,
          selectableListCubit: selectableListCubit,
        ),
        Spacer(),
        ConditionalSynchronizeProfilesButton(
          imageListActionCubit: imageListActionCubit,
          selectableListCubit: selectableListCubit,
        ),
      ],
    );
  }
}
