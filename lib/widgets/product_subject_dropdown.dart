import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/select_product_subject/select_product_subject.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'model_dropdown.dart';

class ProductSubjectDropdown extends StatefulWidget {
  final int? selectedId;
  final List<int> showIds;
  final ValueChanged<int> onChanged;
  final String? labelText;
  final String? hintText;
  final bool allowingImagePortfolio;

  static const moreId = -1;

  ProductSubjectDropdown({
    required this.selectedId,
    required this.showIds,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.allowingImagePortfolio = false,
  });

  @override
  State<ProductSubjectDropdown> createState() => _ProductSubjectDropdownState();
}

class _ProductSubjectDropdownState extends State<ProductSubjectDropdown> {
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  @override
  Widget build(BuildContext context) {
    _productSubjectsByIdsBloc.setCurrentIds(widget.showIds);

    return StreamBuilder<ModelListByIdsState<int, ProductSubject>>(
      stream: _productSubjectsByIdsBloc.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _productSubjectsByIdsBloc.initialState),
    );
  }

  Widget _buildWithState(ModelListByIdsState<int, ProductSubject> state) {
    if (widget.selectedId != null && !state.objectsByIds.containsKey(widget.selectedId)) {
      return Container(); // Not yet loaded.
    }

    return ModelDropdown<int, ProductSubject>(
      selectedId:   widget.selectedId,
      models:       _getModels(state),
      onIdChanged:  _onIdChanged,
      labelText:    widget.labelText,
      hint:         widget.hintText == null ? null : Text(widget.hintText!),
      trailing: [
        DropdownMenuItem<int>(
          value: ProductSubjectDropdown.moreId,
          child: Text(tr('common.more')),
        ),
      ],
    );
  }

  List<ProductSubject> _getModels(ModelListByIdsState<int, ProductSubject> state) {
    final result = <ProductSubject>[];
    bool selectedFound = false;

    for (final id in widget.showIds) {
      final ps = state.objectsByIds[id];
      if (ps == null) continue;
      if (widget.allowingImagePortfolio && !ps.allowsImagePortfolio) continue;
      result.add(ps);

      if (id == widget.selectedId) selectedFound = true;
    }

    if (widget.selectedId != null && !selectedFound) {
      final ps = state.objectsByIds[widget.selectedId];
      if (ps != null) {
        result.add(ps);
      }
    }

    return result;
  }

  // For some reason the direct use of 'onChanged: widget.onChanged' above throws
  //   type '(int) => void' is not a subtype of type '(dynamic) => void'
  // at runtime. So the handler must use dynamic for id and then cast it to int.
  void _onIdChanged(id) {
    switch (id) {
      case ProductSubjectDropdown.moreId:
        _handleMore();
        break;
      default:
        widget.onChanged(id as int);
    }
  }

  void _handleMore() async {
    final id = await SelectProductSubjectScreen.selectSubjectId(
      context: context,
      allowingImagePortfolio: widget.allowingImagePortfolio,
    );

    if (id != null) {
      widget.onChanged(id);
    }
  }
}
