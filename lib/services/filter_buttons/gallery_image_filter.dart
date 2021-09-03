import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/services/filter_buttons/abstract.dart';

class GalleryImageFilterButtonService extends AbstractFilterButtonService<GalleryImageFilter>{
  FilterButtonInfo getFilterButtonInfo(GalleryImageFilter filter) {
    int constraintCount = 0;

    if (filter.formats.isNotEmpty) constraintCount++;
    if (filter.location != null) constraintCount++;
    if (filter.price != null) constraintCount++;

    return FilterButtonInfo(
      constraintCount: constraintCount,
    );
  }
}
