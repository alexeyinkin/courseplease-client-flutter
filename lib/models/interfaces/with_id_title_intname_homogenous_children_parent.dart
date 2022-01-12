import 'package:courseplease/models/interfaces/with_intname.dart';
import 'package:model_interfaces/model_interfaces.dart';

abstract class WithIdTitleIntNameHomogenousChildrenParent<I, O extends WithIdTitleIntNameHomogenousChildrenParent<I, O>> implements
  WithIdTitle<I>,
  WithIdHomogenousChildrenParent<I, O>,
  WithIntName
{
  static String getIntNamePath<I, O extends WithIdTitleIntNameHomogenousChildrenParent<I, O>>(O obj, String separator) {
    return WithHomogenousParent
        .withAncestors(obj)
        .map((obj) => obj.intName)
        .toList(growable: false)
        .reversed
        .join(separator);
  }
}
