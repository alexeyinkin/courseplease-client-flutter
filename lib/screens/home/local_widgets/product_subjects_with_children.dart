import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/home/local_widgets/product_subject_with_image_and_children.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';

class ProductSubjectsWithChildrenWidget extends StatelessWidget {
  final List<ProductSubject> subjects;
  final ValueChanged<int>? onChanged;

  ProductSubjectsWithChildrenWidget({
    required this.subjects,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final subject in subjects) {
      children.add(
        ProductSubjectWithImageAndChildren(
          subject: subject,
          onChanged: onChanged,
        ),
      );
    }

    return ListView(
      children: alternateWidgetListWith(children, SmallPadding()),
    );
  }
}
