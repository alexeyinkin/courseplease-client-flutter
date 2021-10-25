import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

class ModelBuilderWidget<
  I,
  O extends WithId<I>,
  R extends AbstractRepository<I, O>
> extends StatefulWidget {
  final I id;
  final ValueFinalWidgetBuilder<O> builder;
  final O? defaultModel;

  ModelBuilderWidget({
    required this.id,
    required this.builder,
    this.defaultModel,
  }) : super(
    key: ValueKey('model_' + id.toString())
  );

  @override
  _ModelBuilderWidgetState createState() => _ModelBuilderWidgetState<I, O, R>();
}

class _ModelBuilderWidgetState<
  I,
  O extends WithId<I>,
  R extends AbstractRepository<I, O>
> extends State<ModelBuilderWidget<I, O, R>> {
  final _modelByIdBloc = ModelByIdBloc<I, O>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<I, O, R>(),
  );

  @override
  void initState() {
    super.initState();
    _modelByIdBloc.setCurrentId(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelByIdState<I, O>>(
      stream: _modelByIdBloc.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _modelByIdBloc.initialState),
    );
  }

  Widget _buildWithState(ModelByIdState<I, O> modelByIdState) {
    final obj = modelByIdState.object;

    return obj == null
        ? _buildWithoutModel(modelByIdState)
        : widget.builder(context, obj);
  }

  Widget _buildWithoutModel(ModelByIdState<I, O> modelByIdState) {
    if (widget.defaultModel != null) {
      return widget.builder(context, widget.defaultModel!);
    }

    switch (modelByIdState.requestStatus) {
      case RequestStatus.notTried:
      case RequestStatus.loading:
        return Container();
      default:
        return Center(child: Icon(Icons.error));
    }
  }
}
