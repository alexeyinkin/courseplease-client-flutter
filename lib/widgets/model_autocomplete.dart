import 'package:courseplease/blocs/editors/text.dart';
import 'package:courseplease/services/suggest/abstract.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:model_interfaces/model_interfaces.dart';

class ModelAutocomplete<O extends WithIdTitle> extends StatefulWidget {
  final TextValueEditorController<O> controller;
  final int minLength;
  final ValueGetter<AbstractSuggestionService<O>?> suggestionServiceBuilder;
  final String? labelText;

  ModelAutocomplete({
    required this.controller,
    required this.minLength,
    required this.suggestionServiceBuilder,
    this.labelText,
  });

  @override
  _ModelAutocompleteState<O> createState() => _ModelAutocompleteState<O>();
}

class _ModelAutocompleteState<O extends WithIdTitle> extends State<ModelAutocomplete<O>> {
  late final AbstractSuggestionService<O>? _suggestionService;

  @override
  void initState() {
    super.initState();
    _suggestionService = widget.suggestionServiceBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return _suggestionService == null
        ? _buildDisabled()
        : _buildEnabled();
  }

  Widget _buildDisabled() {
    return AppTextField(
      controller: widget.controller.textEditingController,
      enabled: false,
      labelText: widget.labelText,
    );
  }

  Widget _buildEnabled() {
    return TypeAheadField<O>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller.textEditingController,
        decoration: getInputDecoration(context: context, labelText: widget.labelText),
        cursorColor: getTextColor(context),
      ),
      suggestionsCallback: _suggest,
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.title),
        );
      },
      onSuggestionSelected: _onSuggestionSelected,
      loadingBuilder: (context) => Container(),
      noItemsFoundBuilder: _buildNoItemsFound,
    );
  }

  Future<List<O>> _suggest(String str) async {
    if (str.length < widget.minLength) return [];
    return _suggestionService!.suggest(str);
  }

  void _onSuggestionSelected(O model) {
    widget.controller.setValue(model);
  }

  Widget _buildNoItemsFound(BuildContext context) {
    if (widget.controller.textEditingController.text.length < widget.minLength) {
      return Container(height: 0);
    }

    return ListTile(
      title: Text(tr('ModelAutocomplete.notFound')),
    );
  }
}
