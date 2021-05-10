import 'package:courseplease/blocs/models_by_ids.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/product_subjects_by_ids_builder.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProductSubjectWidget extends StatelessWidget {
  final int id;
  final String? translationKey;
  final String? translationPlaceholder;

  ProductSubjectWidget({
    required this.id,
    this.translationKey,
    this.translationPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    return ProductSubjectsByIdsBuilder(
      ids: [id],
      builder: _buildWithState,
    );
  }

  Widget _buildWithState(BuildContext context, ModelListByIdsState<ProductSubject>? state) {
    if (state == null || state.objects.isEmpty) {
      return SmallCircularProgressIndicator(scale: .5);
    }

    return Text(_getText(state));
  }

  String _getText(ModelListByIdsState<ProductSubject> state) {
    if (translationKey == null || translationPlaceholder == null) {
      return state.objects.first.title;
    }

    return tr(
      translationKey!,
      namedArgs: {translationPlaceholder!: state.objects.first.title},
    );
  }
}
