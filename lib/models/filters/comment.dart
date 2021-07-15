import 'package:courseplease/models/filters/abstract.dart';

class CommentFilter extends AbstractFilter {
  final String catalog;
  final int objectId;

  CommentFilter({
    required this.catalog,
    required this.objectId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'catalog':  catalog,
      'objectId': objectId,
    };
  }
}
