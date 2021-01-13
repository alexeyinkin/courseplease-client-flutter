import 'package:meta/meta.dart';
import 'interfaces.dart';

class ProductSubject implements WithIdTitle<int>, WithIdChildren<int, ProductSubject> {
  final int id;
  final String title;
  final List<ProductSubject> children;
  ProductSubject parent; // Nullable

  ProductSubject({
    @required this.id,
    @required this.title,
    @required this.children,
  });

  factory ProductSubject.fromMap(Map<String, dynamic> map) {
    final children = <ProductSubject>[];

    for (final child in map['children']) {
      children.add(ProductSubject.fromMap(child));
    }

    final result = ProductSubject(
      id: map['id'],
      title: map['title'],
      children: children,
    );

    for (final child in children) {
      child.parent = result;
    }

    return result;
  }
}
