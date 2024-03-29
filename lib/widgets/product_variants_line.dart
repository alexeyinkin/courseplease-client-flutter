import 'package:flutter/material.dart';
import 'package:model_interfaces/model_interfaces.dart';
import 'readonly_tags.dart';

class ProductVariantsLineWidget extends StatelessWidget {
  final List<WithTitle> formats;

  ProductVariantsLineWidget({
    required this.formats,
  });

  @override
  Widget build(BuildContext context) {
    final titles = <String>[];
    for (final format in formats) {
      titles.add(format.title);
    }
    return ReadonlyTagsWidget(tags: titles);
  }
}
