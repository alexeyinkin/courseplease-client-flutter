import 'package:app_state/app_state.dart';

class ProductSubjectSelectedEvent extends PageBlocCloseEvent {
  final int productSubjectId;

  ProductSubjectSelectedEvent({
    required this.productSubjectId,
  });
}
