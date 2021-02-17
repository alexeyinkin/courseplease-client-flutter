import 'dart:async';
import 'package:charcode/html_entity.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/blocs/sort_unsorted.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/widgets/contact_title.dart';
import 'package:courseplease/widgets/image_grid.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/product_subject_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EditImageListScreen extends StatefulWidget {
  static const routeName = '/editImageList';

  @override
  State<EditImageListScreen> createState() => _EditImageListScreenState();
}

class _EditImageListScreenState extends State<EditImageListScreen> {
  final _imageSelectionCubit = SelectableListCubit<int>();
  StreamSubscription _imageSelectionSubscription;
  SortUnsortedImagesCubit _sortUnsortedImagesCubit;

  EditImageFilter _filter;
  Map<int, EditableContact> _contactsByIds;

  _EditImageListScreenState() {
    _sortUnsortedImagesCubit = SortUnsortedImagesCubit(listStateCubit: _imageSelectionCubit);
    _imageSelectionSubscription = _imageSelectionCubit.outState.listen(_onSelectionChange);
  }

  @override
  Widget build(BuildContext context) {
    _loadIfNot();

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
      ),
      body: Column(
        children: [
          _buildActionToolbar(),
          Expanded(
            child: EditImageGrid(
              filter: _filter,
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              listStateCubit: _imageSelectionCubit,
              showMappingsOverlay: true,
            ),
          ),
          _buildSelectionToolbar(),
        ],
      ),
    );
  }

  void _loadIfNot() {
    if (_filter != null) return;

    final arguments = ModalRoute.of(context).settings.arguments as EditImageListArguments;
    _filter = arguments.filter;
    _contactsByIds = arguments.contactsByIds;
  }

  Widget _buildTitle() {
    final widgets = <Widget>[];
    String trailing = null;

    switch (_filter.contactIds.length) {
      case 0:
        break;
      case 1:
        final contactId = _filter.contactIds[0];
        if (!_contactsByIds.containsKey(contactId)) {
          widgets.add(Text("1 Profile"));
        } else {
          widgets.add(ContactTitleWidget(contact: _contactsByIds[contactId]));
        }
        trailing = "All Images";
        break;
      default:
        widgets.add(Text(_filter.contactIds.length.toString() + " Profiles"));
        trailing = "All Images";
    }

    if (_filter.unsorted) {
      trailing = AppLocalizations.of(context).sortImportedMedia;
    } else {
      switch (_filter.albumIds.length) {
        case 0:
          break;
        case 1:
          trailing = "1 Album"; // TODO: Show album's title.
          break;
        default:
          trailing = _filter.contactIds.length.toString() + " Albums";
      }
    }

    if (trailing != null) {
      widgets.add(Text(trailing));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: alternateWidgetListWith(
        widgets,
        Text(' ' + String.fromCharCode($mdash) + ' '),
      ), // em dash
      //spacing: 10,
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
      stream: _imageSelectionCubit.outState,
      initialData: _imageSelectionCubit.initialState,
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
    _imageSelectionCubit.selectAll();
  }

  void _selectNone() {
    _imageSelectionCubit.selectNone();
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
    _imageSelectionSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}

class EditImageListArguments {
  final EditImageFilter filter;
  final Map<int, EditableContact> contactsByIds;

  EditImageListArguments({
    @required this.filter,
    @required Map<int, EditableContact> contactsByIds, // Nullable
  }) :
      this.contactsByIds = contactsByIds ?? Map<int, EditableContact>()
  ;
}
