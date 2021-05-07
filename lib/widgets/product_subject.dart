import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProductSubjectWidget extends StatefulWidget {
  final int id;
  final String? translationKey;
  final String? translationPlaceholder;

  ProductSubjectWidget({
    required this.id,
    this.translationKey,
    this.translationPlaceholder,
  });

  @override
  _ProductSubjectWidgetState createState() => _ProductSubjectWidgetState();
}

class _ProductSubjectWidgetState extends State<ProductSubjectWidget> {
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  @override
  void initState() {
    super.initState();
    _productSubjectsByIdsBloc.setCurrentIds([widget.id]);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelListByIdsState<ProductSubject>>(
      stream: _productSubjectsByIdsBloc.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(ModelListByIdsState<ProductSubject>? state) {
    if (state == null || state.objects.isEmpty) {
      return SmallCircularProgressIndicator(scale: .5);
    }

    return Text(_getText(state));
  }

  String _getText(ModelListByIdsState<ProductSubject> state) {
    if (widget.translationKey == null || widget.translationPlaceholder == null) {
      return state.objects.first.title;
    }

    return tr(
      widget.translationKey!,
      namedArgs: {widget.translationPlaceholder!: state.objects.first.title},
    );
  }
}
