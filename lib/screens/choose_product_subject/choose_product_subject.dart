import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter_treeview/tree_view.dart';
import 'package:get_it/get_it.dart';

class ChooseProductSubjectScreen extends StatefulWidget {
  static const routeName = '/chooseProductSubject';

  @override
  State<ChooseProductSubjectScreen> createState() => _ChooseProductSubjectScreenState();
}

class _ChooseProductSubjectScreenState extends State<ChooseProductSubjectScreen> {
  final _productSubjectCacheBloc = GetIt.instance.get<ProductSubjectCacheBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Subject"),
      ),
      body: StreamBuilder(
        stream: _productSubjectCacheBloc.outTopLevelObjects,
        initialData: <ProductSubject>[],
        builder: (context, snapshot) => _buildWithTopLevelObjects(snapshot.data),
      ),
    );
  }

  Widget _buildWithTopLevelObjects(List<ProductSubject> objects) {
    final treeViewController = TreeViewController(children: _objectsToTreeNodes(objects));

    return TreeView(
      controller: treeViewController,
      onNodeTap: _handleNodeTap,
      theme: TreeViewTheme(
        colorScheme: Theme.of(context).colorScheme,
      ),
    );
  }

  List<Node<ProductSubject>> _objectsToTreeNodes(List<ProductSubject> objects) {
    return objects
        .map(_objectToTreeNode)
        .toList();
  }

  Node<ProductSubject> _objectToTreeNode(ProductSubject object) {
    return Node<ProductSubject>(
      key: object.id.toString(),
      label: object.title,
      children: _objectsToTreeNodes(object.children),
      expanded: true,
    );
  }

  void _handleNodeTap(String key) {
    Navigator.of(context).pop(int.parse(key));
  }
}
