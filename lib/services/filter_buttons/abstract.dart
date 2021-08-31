import 'package:courseplease/models/filters/abstract.dart';

abstract class AbstractFilterButtonService<F extends AbstractFilter> {
  FilterButtonInfo getFilterButtonInfo(F filter);
}

class FilterButtonInfo {
  final int constraintCount;

  FilterButtonInfo({
    required this.constraintCount,
  });
}
