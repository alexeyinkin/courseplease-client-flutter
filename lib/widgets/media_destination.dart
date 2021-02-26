import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'buttons.dart';
import 'image_grid.dart';

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
  final List<Widget> previewWidgets;

  MediaDestinationDialog({
    @required this.listActionCubit,
    @required this.mediaDestinationCubit,
    @required this.selectableListState,
    @required this.action,
    this.previewWidgets = const <Widget>[],
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
          ...previewWidgets,
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

  static void show<
    I,
    O extends WithId<I>,
    F extends AbstractFilter,
    R extends AbstractFilteredRepository<I, O, F>
  >({
    BuildContext context,
    SelectableListState selectableListState,
    ListActionCubit listActionCubit,
    ValueChanged<MediaDestinationState> onActionPressed,
  }) async {
    final entityType = typeOf<O>();
    if (entityType != ImageEntity) { // TODO: Generalize beyond images.
      throw UnimplementedError();
    }

    final mediaDestinationCubit = MediaDestinationCubit();
    mediaDestinationCubit.outAction.listen(onActionPressed);

    final filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();
    final idsSubsetFilter = IdsSubsetFilter<I, O>(
      ids: selectableListState.selectedIds.keys.toList(growable: false),
      nestedList: filteredModelListCache.getOrCreate<I, O, F, R>(selectableListState.filter),
    );

    await showDialog(
      context: context,
      builder: (context) => MediaDestinationDialog(
        listActionCubit: listActionCubit,
        mediaDestinationCubit: mediaDestinationCubit,
        selectableListState: selectableListState,
        action: MediaDestinationAction.copy,
        previewWidgets: [
          ResponsiveImageGrid(
            idsSubsetFilter: idsSubsetFilter as IdsSubsetFilter<int, ImageEntity>,
            reserveHeight: 400,
          ),
        ],
      ),
    );

    mediaDestinationCubit.dispose();
  }
}
