import 'package:courseplease/models/geo/country.dart';
import 'package:courseplease/repositories/country.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../all_models_dropdown.dart';
import '../flag_icon.dart';
import '../pad.dart';

class CountryDropdown extends StatelessWidget {
  final String? countryCode;
  final ValueChanged<String> onChanged;

  CountryDropdown({
    required this.countryCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final countryCache = GetIt.instance.get<ModelCacheCache>().getOrCreate<String, Country, CountryRepository>();
    return AllModelsDropdown<String, Country>(
      selectedId:     countryCode,
      modelCacheBloc: countryCache,
      onChanged:      onChanged,
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
