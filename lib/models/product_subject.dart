import 'interfaces.dart';

class ProductSubject implements
    WithIdTitle<int>,
    WithIdTitleChildrenParent<int, ProductSubject, ProductSubject>
{
  final int id;
  final String title;
  final List<String> coverUrls;
  final bool allowsImagePortfolio;
  final List<ProductSubject> children;
  ProductSubject? parent;

  ProductSubject({
    required this.id,
    required this.title,
    required this.coverUrls,
    required this.allowsImagePortfolio,
    required this.children,
  });

  factory ProductSubject.fromMap(Map<String, dynamic> map) {
    final children = <ProductSubject>[];

    for (final child in map['children']) {
      children.add(ProductSubject.fromMap(child));
    }

    final result = ProductSubject(
      id:                   map['id'],
      title:                map['title'],
      coverUrls:            map['coverUrls'].cast<String>(),
      allowsImagePortfolio: map['allowsImagePortfolio'],
      children:             children,
    );

    for (final child in children) {
      child.parent = result;
    }

    return result;
  }
}
