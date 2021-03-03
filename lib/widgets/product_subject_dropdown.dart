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
  final int selectedId;
  final List<int> showIds;
  final ValueChanged<int> onChanged;
  final Widget hint; // Nullable

  static const moreId = -1;

  ProductSubjectDropdown({
    @required this.selectedId,
    @required this.showIds,
    @required this.onChanged,
    this.hint,
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
    return ModelDropdown<int, ProductSubject>(
      selectedId:         widget.selectedId,
      showIds:            _getShowIds(),
      modelListByIdsBloc: _productSubjectsByIdsBloc,
      onChanged:          _handleChange,
      hint:               widget.hint,
      trailing: [
        DropdownMenuItem<int>(
          value: ProductSubjectDropdown.moreId,
          child: Text(tr('common.more')),
        ),
      ],
    );
  }

  List<int> _getShowIds() {
    final result = List<int>.from(widget.showIds);

    if (!result.contains(widget.selectedId)) {
      result.add(widget.selectedId);
    }

    return result;
  }

  // For some reason the direct use of 'onChanged: widget.onChanged' above throws
  //   type '(int) => void' is not a subtype of type '(dynamic) => void'
  // at runtime. So the handler must use dynamic for id and then cast it to int.
  void _handleChange(id) {
    switch (id) {
      case ProductSubjectDropdown.moreId:
        _handleMore();
        break;
      default:
        widget.onChanged(id as int);
    }
  }

  void _handleMore() async {
    final id = await Navigator.of(context).pushNamed(
      SelectProductSubjectScreen.routeName,
    );

    if (id != null) {
      widget.onChanged(id);
    }
  }
}
