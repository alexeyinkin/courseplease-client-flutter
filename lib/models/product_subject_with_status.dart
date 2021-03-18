import 'package:courseplease/models/product_subject.dart';

class ProductSubjectWithStatus {
  final ProductSubject subject;
  final ProductSubjectStatus status;

  ProductSubjectWithStatus({
    required this.subject,
    required this.status,
  });
}

enum ProductSubjectStatus {
  ancestor,   // Above the current one.
  current,    // Currently being viewed.
  descendant, // Below the current one, if we viewed some subject below and then navigated upwards.
}
