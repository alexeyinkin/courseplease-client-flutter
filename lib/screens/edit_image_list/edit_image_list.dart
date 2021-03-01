import 'dart:async';
import 'package:charcode/html_entity.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/unsorted_image_list_toolbar.dart';
import 'package:courseplease/widgets/contact_title.dart';
import 'package:courseplease/widgets/image_grid.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'local_widgets/sorted_image_list_toolbar.dart';

class EditImageListScreen extends StatefulWidget {
  static const routeName = '/editImageList';

  @override
  State<EditImageListScreen> createState() => _EditImageListScreenState();
}

class _EditImageListScreenState extends State<EditImageListScreen> {
  final _selectableListCubit = SelectableListCubit<int, EditImageFilter>();
  StreamSubscription _selectableListSubscription;
  ImageListActionCubit _imageListActionCubit;

  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  EditImageFilter _filter;
  Map<int, EditableContact> _contactsByIds;

  _EditImageListScreenState() {
    _selectableListSubscription = _selectableListCubit.outState.listen(_onSelectionChange);
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
              listStateCubit: _selectableListCubit,
              showStatusOverlay: true,
              showMappingsOverlay: true,
            ),
          ),
        ],
      ),
    );
  }

  void _loadIfNot() {
    if (_filter != null) return;

    final arguments = ModalRoute.of(context).settings.arguments as EditImageListArguments;
    _filter = arguments.filter;
    _contactsByIds = arguments.contactsByIds;

    _selectableListCubit.setFilter(_filter);
    _productSubjectsByIdsBloc.setCurrentIds(_filter.subjectIds);
    _imageListActionCubit = ImageListActionCubit(filter: _filter);
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
          widgets.add(Text(plural('EditImageListScreen.title.profiles', 1)));
        } else {
          widgets.add(ContactTitleWidget(contact: _contactsByIds[contactId]));
        }
        trailing = tr('EditImageListScreen.title.allImages');
        break;
      default:
        widgets.add(Text(plural('EditImageListScreen.title.profiles', _filter.contactIds.length)));
        trailing = tr('EditImageListScreen.title.allImages');
    }

    if (_filter.unsorted) {
      trailing = tr('MyProfileWidget.sortImportedMedia');
    } else {
      switch (_filter.albumIds.length) {
        case 0:
          break;
        case 1:
          trailing = plural('EditImageListScreen.title.albums', 1); // TODO: Show the album title.
          break;
        default:
          trailing = plural('EditImageListScreen.title.profiles', _filter.contactIds.length);
      }
    }

    if (trailing != null) {
      widgets.add(Text(trailing));
    }

    switch (_filter.purposeIds.length) {
      case 0:
        break;
      case 1:
        widgets.add(
          StreamBuilder(
            stream: _productSubjectsByIdsBloc.outState,
            builder: (context, snapshot) => _getAlbumPurposeWidget(_filter.purposeIds[0], snapshot.data),
          ),
        );
        break;
      default:
        widgets.add(Text(plural('EditImageListScreen.title.purposes', _filter.purposeIds.length)));
    }

    switch (_filter.subjectIds.length) {
      case 0:
        break;
      case 1:
        widgets.add(
          StreamBuilder(
            stream: _productSubjectsByIdsBloc.outState,
            initialData: _productSubjectsByIdsBloc.initialState,
            builder: (context, snapshot) => _getProductSubjectTitleWidget(snapshot.data),
          ),
        );
        break;
      default:
        widgets.add(Text(plural('EditImageListScreen.title.subjects', _filter.purposeIds.length)));
    }

    if (widgets.isEmpty) {
      widgets.add(Text(tr('EditImageListScreen.title.allMyImages')));
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

  Widget _getAlbumPurposeWidget(int purposeId, ModelListByIdsState<ProductSubject> subjectsState) {
    final key = subjectsState == null || subjectsState.objects.length != 1
        ? purposeId.toString() + '_asTheOnly'
        : ImageAlbumPurpose.getTitleKey(purposeId, subjectsState.objects[0]);

    return Text(tr('models.Image.purposes.' + key));
  }

  Widget _getProductSubjectTitleWidget(ModelListByIdsState<ProductSubject> state) {
    if (state.objects.isNotEmpty) {
      return Text(state.objects[0].title);
    }

    return SmallCircularProgressIndicator();
  }

  Widget _buildActionToolbar() {
    if (_filter.unsorted) {
      return UnsortedImageListToolbar(
        imageListActionCubit: _imageListActionCubit,
        selectableListCubit: _selectableListCubit,
      );
    }

    return SortedImageListToolbar(
      imageListActionCubit: _imageListActionCubit,
      selectableListCubit: _selectableListCubit,
    );
  }

  void _onSelectionChange(SelectableListState selectionState) {
    if (selectionState.wasEmptied) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _selectableListSubscription.cancel();
    super.dispose();
  }
}

class EditImageListArguments {
  final EditImageFilter filter;
  final Map<int, EditableContact> contactsByIds;

  EditImageListArguments({
    @required this.filter,
    Map<int, EditableContact> contactsByIds, // Nullable
  }) :
      this.contactsByIds = contactsByIds ?? Map<int, EditableContact>()
  ;
}
