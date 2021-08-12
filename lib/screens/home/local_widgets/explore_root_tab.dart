import 'package:courseplease/blocs/tree_position.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/screens/home/local_widgets/product_subjects_with_children.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExploreRootTabWidget extends StatelessWidget {
  final TreePositionState<int, ProductSubject> treePositionState;
  final ValueChanged<int> onSubjectChanged;

  ExploreRootTabWidget({
    required this.treePositionState,
    required this.onSubjectChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('ExploreRootTabWidget.title'),
            style: AppStyle.h2,
          ),
          Container(height: 20),
          Expanded(
            child: ProductSubjectsWithChildrenWidget(
              subjects: treePositionState.currentChildren,
              onChanged: onSubjectChanged,
            ),
          ),
        ],
      ),
    );
  }
}
