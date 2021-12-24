import 'package:courseplease/models/interfaces/with_intname.dart';
import 'package:model_interfaces/model_interfaces.dart';

abstract class WithHomogenousParentIntName<T extends WithHomogenousParentIntName<T>> implements
  WithHomogenousParent<T>,
  WithIntName
{
  static String getIntNamePath<T extends WithHomogenousParentIntName<T>>(T obj, String separator) {
    return WithHomogenousParent
        .withAncestors(obj)
        .map((obj) => obj.intName)
        .toList(growable: false)
        .reversed
        .join(separator);
  }
}
