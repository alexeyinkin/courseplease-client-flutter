import 'dart:async';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/blocs/sort_unsorted.dart';
import 'package:courseplease/widgets/image_grid.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SortUnsortedMediaScreen extends StatefulWidget {
  static const routeName = '/sortUnsortedMedia';

  @override
  State<SortUnsortedMediaScreen> createState() => _SortUnsortedMediaScreenState();
}

class _SortUnsortedMediaScreenState extends State<SortUnsortedMediaScreen> {
  final _photoListCubit = SelectableListCubit<int>();
  StreamSubscription _photoSelectionSubscription;
  SortUnsortedImagesCubit _sortUnsortedImagesCubit;

  _SortUnsortedMediaScreenState() {
    _sortUnsortedImagesCubit = SortUnsortedImagesCubit(listStateCubit: _photoListCubit);
    _photoSelectionSubscription = _photoListCubit.outState.listen(_onSelectionChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sortImportedMedia),
      ),
      body: Column(
        children: [
          _buildActionToolbar(),
          Expanded(
            child: UnsortedPhotoGrid(
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              listStateCubit: _photoListCubit,
            ),
          ),
          _buildSelectionToolbar(),
        ],
      ),
    );
  }

  Widget _buildActionToolbar() {
    return StreamBuilder(
      stream: _sortUnsortedImagesCubit.outState,
      initialData: _sortUnsortedImagesCubit.initialState,
      builder: (context, snapshot) => _buildActionToolbarWithState(snapshot.data),
    );
  }

  Widget _buildActionToolbarWithState(SortUnsortedState actionState) {
    // TODO: Use flex? Test on small screens.
    return Row(
      children: [
        padRight(
          ElevatedButton(
            onPressed: actionState.canPublish ? _onPublishPressed : null,
            child: Text(AppLocalizations.of(context).sortImportedPublishButton),
          ),
        ),
        padRight(Text(AppLocalizations.of(context).sortImportedPublishAs)),
        padRight(_buildAlbumDropdownButton(actionState)),
        padRight(Text(AppLocalizations.of(context).sortImportedPublishInSubject)),
        padRight(
          ProductSubjectDropdown(
            selectedId: actionState.subjectId,
            showIds: actionState.showSubjectIds,
            onChanged: _sortUnsortedImagesCubit.setSubjectId,
            hint: Text(AppLocalizations.of(context).sortImportedSelectSubject),
          ),
        ),
        Spacer(),
        ElevatedButton(
          onPressed: actionState.canDelete ? _onDeletePressed : null,
          child: Icon(Icons.delete_forever),
        )
      ],
    );
  }

  Widget _buildAlbumDropdownButton(SortUnsortedState actionState) {
    final items = <DropdownMenuItem<PublishAction>>[];

    for (final action in actionState.showActions) {
      items.add(_buildActionDropdownMenuItem(action));
    }

    return DropdownButton<PublishAction>(
      value: actionState.action,
      onChanged: _sortUnsortedImagesCubit.setAction,
      hint: Text(AppLocalizations.of(context).sortImportedSelectAlbum),
      items: items,
    );
  }

  Widget _buildActionDropdownMenuItem(PublishAction action) {
    String text;

    switch (action) {
      case PublishAction.portfolio:
        text = AppLocalizations.of(context).albumMyPortfolio;
        break;
      case PublishAction.customersPortfolio:
        text = AppLocalizations.of(context).albumMyStudentsPortfolio;
        break;
      case PublishAction.backstage:
        text = AppLocalizations.of(context).albumBackstage;
        break;
    }

    return DropdownMenuItem<PublishAction>(
      value: action,
      child: Text(text),
    );
  }

  Widget _buildSelectionToolbar() {
    return StreamBuilder(
      stream: _photoListCubit.outState,
      initialData: _photoListCubit.initialState,
      builder: (context, snapshot) => _buildSelectionToolbarWithState(snapshot.data),
    );
  }

  Widget _buildSelectionToolbarWithState(SelectableListState selectionState) {
    return Row(
      children: [
        padRight(
          ElevatedButton(
            onPressed: selectionState.canSelectMore ? _selectAll : null,
            // TODO: Use better icons, awaiting them here: https://github.com/Templarian/MaterialDesign/issues/5853
            child: Icon(FlutterIcons.checkbox_multiple_marked_mco),
          ),
        ),
        padRight(
          ElevatedButton(
            onPressed: selectionState.selected ? _selectNone : null,
            child: Icon(FlutterIcons.checkbox_multiple_blank_mco),
          ),
        ),
        Text(AppLocalizations.of(context).selectedCount(
            selectionState.selectedIds.length)),
      ],
    );
  }

  void _selectAll() {
    _photoListCubit.selectAll();
  }

  void _selectNone() {
    _photoListCubit.selectNone();
  }

  void _onPublishPressed() {
    _sortUnsortedImagesCubit.publishSelected();
  }

  void _onDeletePressed() {
    _sortUnsortedImagesCubit.deleteSelected();
  }

  void _onSelectionChange(SelectableListState selectionState) {
    if (selectionState.wasEmptied) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _photoSelectionSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}
