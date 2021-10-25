import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

typedef Widget ModelListBuilder<I, O extends WithId<I>>(BuildContext context, ModelListByIdsState<I, O>? list);

class ProductSubjectsByIdsBuilder extends StatefulWidget {
  final List<int> ids;
  final ModelListBuilder<int, ProductSubject> builder;

  ProductSubjectsByIdsBuilder({
    required this.ids,
    required this.builder,
  }) : super(
    key: Key('ProductSubject_' + ids.join('_')),
  );

  @override
  _ProductSubjectsByIdsBuilderState createState() => _ProductSubjectsByIdsBuilderState();
}

class _ProductSubjectsByIdsBuilderState extends State<ProductSubjectsByIdsBuilder> {
  final _productSubjectsByIdsBloc = ModelListByIdsBloc<int, ProductSubject>(
    modelCacheBloc: GetIt.instance.get<ProductSubjectCacheBloc>(),
  );

  @override
  void initState() {
    super.initState();
    _productSubjectsByIdsBloc.setCurrentIds(widget.ids);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelListByIdsState<int, ProductSubject>>(
      stream: _productSubjectsByIdsBloc.outState,
      builder: (context, snapshot) => widget.builder(context, snapshot.data),
    );
  }

  @override
  void dispose() {
    _productSubjectsByIdsBloc.dispose();
    super.dispose();
  }
}
