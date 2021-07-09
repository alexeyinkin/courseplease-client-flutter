import 'abstract.dart';

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
