import 'package:courseplease/models/filters/gallery_lesson.dart';
import 'package:courseplease/services/filter_buttons/abstract.dart';

class GalleryLessonFilterButtonService extends AbstractFilterButtonService<GalleryLessonFilter>{
  FilterButtonInfo getFilterButtonInfo(GalleryLessonFilter filter) {
    int constraintCount = 0;

    if (filter.langs.isNotEmpty) constraintCount++;

    return FilterButtonInfo(
      constraintCount: constraintCount,
    );
  }
}
