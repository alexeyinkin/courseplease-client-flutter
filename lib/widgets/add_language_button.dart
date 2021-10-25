import 'package:courseplease/models/language.dart';
import 'package:courseplease/repositories/language.dart';
import 'package:courseplease/widgets/select_item_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

import 'language.dart';

class AddLanguageButton extends StatelessWidget {
  final ValueChanged<Language> onSelected;
  final List<String> unavailableIds;

  AddLanguageButton({
    required this.onSelected,
    required this.unavailableIds,
  });

  @override
  Widget build(BuildContext context) {
    return SelectItemButton<Language>(
      items: _getLanguagesToShow(),
      onSelected: onSelected,
      itemBuilder: (_, language) => LanguageWidget(lang: language.id),
      iconData: Icons.add,
    );
  }

  List<Language> _getLanguagesToShow() {
    final repository = GetIt.instance.get<LanguageRepository>();
    final map = Map<String, Language>.from(repository.map);

    for (final unavailableId in unavailableIds) {
      map.remove(unavailableId);
    }

    final result = map.values.toList(growable: false);
    result.sort(WithTitle.compareCaseInsensitive);
    return result;
  }
}
