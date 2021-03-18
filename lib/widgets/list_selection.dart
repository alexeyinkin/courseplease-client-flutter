import 'package:courseplease/widgets/list_action.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ListSelectionWidget extends AbstractListSelectionWidget {
  ListSelectionWidget({
    required SelectableListCubit selectableListCubit,
  }) : super(
    selectableListCubit: selectableListCubit,
  );

  @override
  Widget buildWithSelectableListState({
    required BuildContext context,
    required SelectableListState selectableListState,
  }) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: selectableListState.canSelectMore ? _selectAll : null,
          // TODO: Use better icons, awaiting them here: https://github.com/Templarian/MaterialDesign/issues/5853
          child: Icon(FlutterIcons.checkbox_multiple_marked_mco),
        ),
        SmallPadding(),
        ElevatedButton(
          onPressed: selectableListState.selected ? _selectNone : null,
          child: Icon(FlutterIcons.checkbox_multiple_blank_mco),
        ),
      ],
    );
  }

  void _selectAll() {
    selectableListCubit.selectAll();
  }

  void _selectNone() {
    selectableListCubit.selectNone();
  }
}
