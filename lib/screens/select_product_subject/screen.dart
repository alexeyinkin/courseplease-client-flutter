import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:get_it/get_it.dart';

import 'bloc.dart';
import 'events.dart';

class SelectProductSubjectScreen extends StatelessWidget {
  final SelectProductSubjectBloc bloc;

  SelectProductSubjectScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    final productSubjectCacheBloc = GetIt.instance.get<ProductSubjectCacheBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('SelectProductSubjectScreen.title')),
      ),
      body: StreamBuilder<List<ProductSubject>>(
        stream: productSubjectCacheBloc.outTopLevelObjects,
        builder: (context, snapshot) => _buildWithTopLevelObjects(snapshot.data),
      ),
    );
  }

  Widget _buildWithTopLevelObjects(List<ProductSubject>? objects) {
    if (objects == null) {
      return Center(child: SmallCircularProgressIndicator());
    }

    final treeViewController = TreeViewController(children: _objectsToTreeNodes(objects));

    return TreeView(
      controller: treeViewController,
      onNodeTap: _handleNodeTap,
    );
  }

  List<Node<ProductSubject>> _objectsToTreeNodes(List<ProductSubject> objects) {
    final result = <Node<ProductSubject>>[];

    for (final obj in objects) {
      final node = _objectToTreeNode(obj);
      if (node == null) continue;

      result.add(node);
    }

    return result;
  }

  Node<ProductSubject>? _objectToTreeNode(ProductSubject object) {
    if (bloc.allowingImagePortfolio && object.allowsImagePortfolio == false) {
      return null;
    }

    return Node<ProductSubject>(
      key: object.id.toString(),
      label: object.title,
      children: _objectsToTreeNodes(object.children),
      expanded: true,
    );
  }

  void _handleNodeTap(String key) {
    final subjectId = int.parse(key);
    bloc.closeScreenWith(ProductSubjectSelectedEvent(productSubjectId: subjectId));
  }
}
