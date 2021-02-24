import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

class MediaDestinationWidget extends StatelessWidget {
  final MediaDestinationCubit mediaDestinationCubit;

  static final purposeNames = {
    ImageAlbumPurpose.portfolio: "My Portfolio",
    ImageAlbumPurpose.customersPortfolio: "My Students' Works",
    ImageAlbumPurpose.backstage: "Other Photos", // TODO: Make dependant on the media type.
  };

  MediaDestinationWidget({
    this.mediaDestinationCubit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: mediaDestinationCubit.outState,
      initialData: mediaDestinationCubit.initialState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(MediaDestinationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getSubjectRow(state),
        _getPurposeRowIfNeed(state),
      ],
    );
  }

  Widget _getSubjectRow(MediaDestinationState state) {
    return Row(
      children: [
        Text("To "),
        ProductSubjectDropdown(
          selectedId: state.subjectId,
          showIds: state.showSubjectIds,
          onChanged: mediaDestinationCubit.setSubjectId,
          hint: Text("(Select a Subject)"),
        ),
      ],
    );
  }

  Widget _getPurposeRowIfNeed(MediaDestinationState state) {
    if (state.showPurposeIds.length < 2) return Container();

    final items = <DropdownMenuItem<int>>[];

    for (final purposeId in state.showPurposeIds) {
      items.add(
        DropdownMenuItem<int>(
          child: Text(MediaDestinationWidget.purposeNames[purposeId] ?? ''),
          value: purposeId,
        ),
      );
    }

    return Row(
      children: [
        Text("As "),
        DropdownButton<int>(
          value: state.purposeId,
          items: items,
          onChanged: mediaDestinationCubit.setPurposeId,
          hint: Text("(Select)"),
        ),
      ],
    );
  }
}

enum MediaDestinationAction {
  publish,
  move,
  copy,
}

class MediaDestinationDialog extends StatelessWidget {
  final ListActionCubit listActionCubit;
  final MediaDestinationCubit mediaDestinationCubit;
  final SelectableListState selectableListState;
  final MediaDestinationAction action;

  MediaDestinationDialog({
    @required this.listActionCubit,
    @required this.mediaDestinationCubit,
    @required this.selectableListState,
    @required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Move N Images"),
      actions: [
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () => _close(context),
        ),
        _getActionButton(),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MediaDestinationWidget(
            mediaDestinationCubit: mediaDestinationCubit,
          ),
        ],
      ),
    );
  }

  Widget _getActionButton() {
    return StreamBuilder(
      stream: listActionCubit.outState,
      initialData: listActionCubit.initialState,
      builder: (context, snapshot) => _buildActionButtonWithActionState(snapshot.data),
    );
  }

  Widget _buildActionButtonWithActionState(ListActionCubitState listActionCubitState) {
    return StreamBuilder(
      stream: mediaDestinationCubit.outState,
      initialData: mediaDestinationCubit.initialState,
      builder: (context, snapshot) => _buildActionButtonWithStates(listActionCubitState, snapshot.data),
    );
  }

  Widget _buildActionButtonWithStates(
    ListActionCubitState listActionCubitState,
    MediaDestinationState mediaDestinationState,
  ) {
    return ElevatedButtonWithProgress(
      child: Text("Go"),
      onPressed: mediaDestinationCubit.onActionPressed,
      isLoading: listActionCubitState.actionInProgress != null,
      enabled: mediaDestinationState.canSubmit,
    );
  }

  void _close(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
