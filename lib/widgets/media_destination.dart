import 'package:courseplease/blocs/list_action/list_action.dart';
import 'package:courseplease/blocs/media_destination.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'buttons.dart';
import 'media/image/responsive_image_grid.dart';

class MediaDestinationWidget extends StatelessWidget {
  final MediaDestinationCubit mediaDestinationCubit;

  MediaDestinationWidget({
    required this.mediaDestinationCubit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaDestinationState>(
      stream: mediaDestinationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? mediaDestinationCubit.initialState),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(tr('MediaDestinationWidget.toSubject')),
        SmallPadding(),
        Expanded(
          child: ProductSubjectDropdown(
            selectedId: state.subjectId,
            showIds: state.showSubjectIds,
            onChanged: mediaDestinationCubit.setSubjectId,
            hintText: tr('MediaDestinationWidget.selectSubject'),
          ),
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
          child: Text(tr('models.Image.purposes.' + purposeId.toString())),
          value: purposeId,
        ),
      );
    }

    return Row(
      children: [
        Text(tr('MediaDestinationWidget.asPurpose')),
        SmallPadding(),
        DropdownButton<int>(
          value: state.purposeId,
          items: items,
          onChanged: mediaDestinationCubit.setPurposeId,
          hint: Text(tr('MediaDestinationWidget.selectPurpose')),
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
    required this.listActionCubit,
    required this.mediaDestinationCubit,
    required this.selectableListState,
    required this.action,
    this.previewWidgets = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    final actionString = _getActionString();
    final nOfTr = plural('MediaDestinationDialog.nOf.image', selectableListState.selectedIds.length);
    final doWithTr = tr('MediaDestinationDialog.doWith.' + actionString, namedArgs:{'what': nOfTr});

    return AlertDialog(
      title: Text(doWithTr),
      actions: [
        ElevatedButton(
          child: Text(tr('common.buttons.cancel')),
          onPressed: () => _close(context),
        ),
        _getActionButton(),
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...previewWidgets,
          SmallPadding(),
          MediaDestinationWidget(
            mediaDestinationCubit: mediaDestinationCubit,
          ),
        ],
      ),
    );
  }

  String _getActionString() {
    return enumValueAfterDot(action);
  }

  Widget _getActionButton() {
    return StreamBuilder<ListActionCubitState>(
      stream: listActionCubit.outState,
      builder: (context, snapshot) => _buildActionButtonWithActionState(snapshot.data ?? listActionCubit.initialState),
    );
  }

  Widget _buildActionButtonWithActionState(ListActionCubitState listActionCubitState) {
    return StreamBuilder<MediaDestinationState>(
      stream: mediaDestinationCubit.outState,
      builder: (context, snapshot) => _buildActionButtonWithStates(
        listActionCubitState,
        snapshot.data ?? mediaDestinationCubit.initialState,
      ),
    );
  }

  Widget _buildActionButtonWithStates(
    ListActionCubitState listActionCubitState,
    MediaDestinationState mediaDestinationState,
  ) {
    final actionString = _getActionString();
    final doTr = tr('MediaDestinationDialog.do.' + actionString);

    return ElevatedButtonWithProgress(
      child: Text(doTr),
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
    required BuildContext context,
    required SelectableListState<I, F> selectableListState,
    required ListActionCubit listActionCubit,
    required ValueChanged<MediaDestinationState> onActionPressed,
    required MediaDestinationAction action,
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
        action: action,
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
