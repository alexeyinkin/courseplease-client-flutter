import 'package:courseplease/blocs/sorted_model_cache.dart';
import 'package:courseplease/models/geo/country.dart';
import 'package:courseplease/repositories/country.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:model_editors/model_editors.dart';

import '../all_models_dropdown.dart';
import '../flag_icon.dart';
import '../pad.dart';

class CountryDropdown extends StatefulWidget {
  final WithIdTitleEditingController<String, Country> controller;

  CountryDropdown({
    required this.controller,
  });

  @override
  _CountryDropdownState createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  final _sortedCountryCache = SortedModelCacheBloc(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<String, Country, CountryRepository>(),
  );

  @override
  Widget build(BuildContext context) {
    final country = widget.controller.value;

    return AllModelsDropdown<String, Country>(
      selectedId:     country?.id,
      modelCacheBloc: _sortedCountryCache,
      onChanged:      (v) => widget.controller.value = v,
      itemBuilder:    _buildItem,
      labelText:      tr('CountryDropdown.label'),
    );
  }

  Widget _buildItem(BuildContext context, Country country) {
    return Row(
      children: [
        FlagIcon(countryCode: country.id),
        SmallPadding(),
        Text(country.title),
      ],
    );
  }
}
