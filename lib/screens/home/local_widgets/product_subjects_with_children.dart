import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/home/local_widgets/product_subject_with_image_and_children.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

    // TODO: Remove after testing, integrate this switch into the UI.
    final appState = GetIt.instance.get<AppState>();
    children.add(
      Row(
        children: [
          ElevatedButton(
            child: Text('en'),
            onPressed: () => appState.langState.setLang('en'),
          ),
          ElevatedButton(
            child: Text('ru'),
            onPressed: () => appState.langState.setLang('ru'),
          ),
          ElevatedButton(
            child: Text('fr'),
            onPressed: () => appState.langState.setLang('fr'),
          ),
        ],
      ),
    );

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
