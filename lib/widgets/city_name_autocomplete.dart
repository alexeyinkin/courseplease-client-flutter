import 'package:courseplease/blocs/editors/with_id_title.dart';
import 'package:courseplease/models/filters/city_name.dart';
import 'package:courseplease/models/geo/city_name.dart';
import 'package:courseplease/repositories/city_name.dart';
import 'package:courseplease/services/suggest/abstract.dart';
import 'package:courseplease/services/suggest/repository.dart';
import 'package:courseplease/widgets/model_autocomplete.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class CityNameAutocomplete extends StatelessWidget {
  final String? countryCode;
  final WithIdTitleEditorController<int, CityName> controller;

  CityNameAutocomplete({
    required this.countryCode,
    required this.controller,
  }) : super(
    key: ValueKey(countryCode)
  );

  @override
  Widget build(BuildContext context) {
    return ModelAutocomplete<CityName>(
      controller: controller,
      minLength: 0,
      suggestionServiceBuilder: _createSuggestionService,
      labelText: tr('CityNameAutocomplete.label'),
    );
  }

  AbstractSuggestionService<CityName>? _createSuggestionService() {
    if (countryCode == null) return null;

    return RepositorySuggestionService<int, CityName, CityNameFilter, CityNameRepository>(
      fixedFilter: CityNameFilter(
        countryCode: countryCode!,
        search: '',
      ),
      filterBuilder: (fixedFilter, search) => fixedFilter.withSearch(search),
    );
  }
}
