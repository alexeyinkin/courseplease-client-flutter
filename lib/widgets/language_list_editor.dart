import 'package:courseplease/blocs/editors/with_id_title_list.dart';
import 'package:courseplease/models/language.dart';
import 'package:courseplease/repositories/language.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/widgets/add_language_button.dart';
import 'package:courseplease/widgets/language.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:model_editors/model_editors.dart';

import 'capsule.dart';

class LanguageListEditor extends StatelessWidget {
  final LanguageListEditorController controller;

  LanguageListEditor({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CapsuleListEditor<Language, WithIdTitleEditingController<String, Language>>(
      controller: controller,
      capsuleContentBuilder: _buildValueEditor,
      addButtonBuilder: _buildAddButton,
    );
  }

  Widget _buildValueEditor(BuildContext context, Language language) {
    return LanguageWidget(lang: language.id);
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: CapsuleWidget.verticalPadding),
      child: AddLanguageButton(
        onSelected: (language) => controller.add(language),
        unavailableIds: controller.getIds(),
      ),
    );
  }
}

class LanguageListEditorController extends WithIdTitleListEditorController<String, Language> {
  LanguageListEditorController() : super(
    maxLength: 10,
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<String, Language, LanguageRepository>(),
  );
}
