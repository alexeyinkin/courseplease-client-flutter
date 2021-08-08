import 'dart:async';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/edit_image_list/local_blocs/image_list_action.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/title.dart';
import 'package:courseplease/screens/edit_image_list/local_widgets/unsorted_image_list_toolbar.dart';
import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:courseplease/widgets/media/image/my_image_grid.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'local_widgets/sorted_image_list_toolbar.dart';

class EditImageListScreen extends StatefulWidget {
  final MyImageFilter filter;
  final Map<int, EditableContact> contactsByIds;

  EditImageListScreen({
    required this.filter,
    required this.contactsByIds,
  });

  @override
  State<EditImageListScreen> createState() => _EditImageListScreenState();

  static Future<void> show({
    required BuildContext context,
    required MyImageFilter filter,
    Map<int, EditableContact>? contactsByIds,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => EditImageListScreen(
          filter: filter,
          contactsByIds: contactsByIds ?? Map<int, EditableContact>(),
        ),
      ),
    );
  }
}

class _EditImageListScreenState extends State<EditImageListScreen> {
  final _selectableListCubit = SelectableListCubit<int, MyImageFilter>(initialFilter: MyImageFilter());
  late final ImageListActionCubit _imageListActionCubit;

  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  _EditImageListScreenState() {
    _selectableListCubit.emptied.listen((_) => _onEmptied());
  }

  @override
  void initState() {
    super.initState();
    _selectableListCubit.setFilter(widget.filter);
    _productSubjectsByIdsBloc.setCurrentIds(widget.filter.subjectIds);
    _imageListActionCubit = ImageListActionCubit(filter: widget.filter);
    _imageListActionCubit.errors.listen((_) => _onError());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleWidget(
          filter: widget.filter,
          contactsByIds: widget.contactsByIds,
          productSubjectsByIdsBloc: _productSubjectsByIdsBloc,
        ),
      ),
      body: Column(
        children: [
          _buildActionToolbar(),
          Expanded(
            child: MyImageGrid(
              filter: widget.filter,
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

  Widget _buildActionToolbar() {
    if (widget.filter.unsorted) {
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

  void _onEmptied() {
    Navigator.of(context).pop();
  }

  void _onError() {
    ErrorPopupScreen.show(context);
  }

  @override
  void dispose() {
    _selectableListCubit.dispose();
    _imageListActionCubit.dispose();
    _productSubjectsByIdsBloc.dispose();
    super.dispose();
  }
}
