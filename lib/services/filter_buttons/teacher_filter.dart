import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/services/filter_buttons/abstract.dart';

class TeacherFilterButtonService extends AbstractFilterButtonService<TeacherFilter>{
  FilterButtonInfo getFilterButtonInfo(TeacherFilter filter) {
    int constraintCount = 0;

    if (filter.formats.isNotEmpty) constraintCount++;
    if (filter.location != null) constraintCount++;
    if (filter.price?.isLimited() ?? false) constraintCount++;
    if (filter.langs.isNotEmpty) constraintCount++;

    return FilterButtonInfo(
      constraintCount: constraintCount,
    );
  }
}
