import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/sorted_image_list_action_widget.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/conditional_synchronize_profiles_button.dart';
import 'package:courseplease/widgets/list_selection.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class SortedImageListToolbar extends StatelessWidget {
  final ImageListActionCubit imageListActionCubit;
  final SelectableListCubit<int, EditImageFilter> selectableListCubit;

  SortedImageListToolbar({
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
        SortedImageListActionWidget(
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
