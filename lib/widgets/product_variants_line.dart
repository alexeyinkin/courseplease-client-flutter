import 'package:courseplease/models/product_variant_format.dart';
import 'package:flutter/material.dart';
import 'readonly_tags.dart';

class ProductVariantsLineWidget extends StatelessWidget {
  final List<ProductVariantFormat> formats;

  ProductVariantsLineWidget({
    @required this.formats,
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
