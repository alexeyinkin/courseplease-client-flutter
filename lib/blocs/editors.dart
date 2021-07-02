import 'dart:async';

import 'package:courseplease/blocs/model_cache.dart';
import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

abstract class AbstractValueEditorController<T> {
  final _changesController = StreamController<void>.broadcast();
  Stream<void> get changes => _changesController.stream;

  final _listeners = <VoidCallback>[];

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void fireChange() {
    _changesController.sink.add(null);

    for (final listener in _listeners) {
      listener();
    }
  }

  void setValue(T? value);
  T? getValue();

  void dispose() {
    _changesController.close();
  }
}

abstract class TextValueEditorController<T> extends AbstractValueEditorController<T> {
  final textEditingController = TextEditingController();

  void dispose() {
    textEditingController.dispose();
  }
}

class WithIdTitleEditorController<I, O extends WithIdTitle<I>> extends TextValueEditorController<O> {
  O? _value;

  @override
  void setValue(O? value) {
    _value = value;
    textEditingController.text = value?.title ?? '';
    super.fireChange();
  }

  @override
  O? getValue() => _value;
}

abstract class AbstractValueListEditorController<
  T,
  C extends AbstractValueEditorController<T>
> extends AbstractValueEditorController<List<T?>> {
  final int maxLength;
  var _controllers = <C>[];

  List<C> get controllers => _controllers;

  AbstractValueListEditorController({
    required this.maxLength,
  });

  @override
  void setValue(List<T?>? values) {
    values = values ?? <T>[];

    if (values.length > maxLength) {
      values = values.sublist(0, maxLength); // Or throw?
    }

    final controllers = <C>[];

    for (final value in values) {
      final controller = createController();
      controller.setValue(value);
      controllers.add(controller);
    }

    // TODO: Dispose old controllers.
    _controllers = controllers;

    fireChange();
  }

  bool get canAdd => _controllers.length < maxLength;

  void add(T? value) {
    final controller = createController();
    controller.setValue(value);
    _controllers.add(controller);

    fireChange();
    // TODO: Focus on the new input.
  }

  @override
  List<T?> getValue() { // List of nullable
    final result = <T?>[]; // List of nullable

    for (final controller in _controllers) {
      result.add(controller.getValue());
    }

    //sortValues(result); // TODO: Allow sorting of nullables?
    return result;
  }

  List<T> getNonNullValues() {
    final result = <T>[];

    for (final controller in _controllers) {
      final value = controller.getValue();
      if (value == null) continue;
      result.add(value);
    }

    sortValues(result);
    return result;
  }

  void sortValues(List<T> values) {
  }

  void deleteController(C controller) {
    _controllers.removeWhere((aController) => aController == controller);
    fireChange();
  }

  C createController();
}

class WithIdTitleListEditorController<
  I,
  O extends WithIdTitle<I>
> extends AbstractValueListEditorController<O, WithIdTitleEditorController<I, O>> {
  final ModelListByIdsBloc<I, O> _modelListByIds;

  WithIdTitleListEditorController({
    required int maxLength,
    required ModelCacheBloc<I, O> modelCacheBloc,
  }) :
      _modelListByIds = ModelListByIdsBloc<I, O>(modelCacheBloc: modelCacheBloc),
      super(
        maxLength: maxLength,
      )
  {
    _modelListByIds.outState.listen(_onStateChanged);
  }

  void _onStateChanged(ModelListByIdsState<O> state) {
    setValue(state.objects);
  }

  List<I> getIds() {
    final result = <I>[];

    for (final obj in getValue()) {
      if (obj == null) continue;
      result.add(obj.id);
    }

    return result;
  }

  void setIds(List<I> ids) {
    _modelListByIds.setCurrentIds(ids);
  }

  @override
  WithIdTitleEditorController<I, O> createController() {
    return WithIdTitleEditorController<I, O>();
  }
}
