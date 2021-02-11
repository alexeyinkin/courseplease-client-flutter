import 'package:courseplease/blocs/selection.dart';
import 'package:courseplease/widgets/image_grid.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SortUnsortedMediaScreen extends StatefulWidget {
  static const routeName = '/sortUnsortedMedia';

  @override
  State<SortUnsortedMediaScreen> createState() => _SortUnsortedMediaScreenState();
}

class _SortUnsortedMediaScreenState extends State<SortUnsortedMediaScreen> {
  final _photoSelection = SelectionCubit<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).sortImportedMedia),
      ),
      body: Column(
        children: [
          _getToolbar(),
          Expanded(
            child: UnsortedPhotoGrid(
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              selectionCubit: _photoSelection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getToolbar() {
    return StreamBuilder(
      stream: _photoSelection.outState,
      initialData: _photoSelection.initialState,
      builder: (context, snapshot) => _buildToolbarWithState(snapshot.data),
    );
  }

  Widget _buildToolbarWithState(SelectionState selectionState) {
    return Row(
      children: [
        padRight(
          ElevatedButton(
            onPressed: selectionState.canSelectMore ? _selectAll : null,
            child: Text(AppLocalizations.of(context).selectAll),
          ),
        ),
        padRight(
          ElevatedButton(
            onPressed: selectionState.selectedIds.isEmpty ? null : _selectNone,
            child: Text(AppLocalizations.of(context).selectNone),
          ),
        ),
        padRight(
          Text(AppLocalizations.of(context).selectedCount(selectionState.selectedIds.length)),
        ),
      ],
    );
  }

  void _selectAll() {
    _photoSelection.selectAll();
  }

  void _selectNone() {
    _photoSelection.clear();
  }
}
