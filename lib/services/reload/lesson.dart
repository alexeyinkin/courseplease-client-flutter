import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/repositories/gallery_lesson.dart';
import 'package:get_it/get_it.dart';

import '../model_cache_factory.dart';

class LessonReloadService {
  void reload(int id) {
    final cache = GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Lesson, GalleryLessonRepository>();
    cache.reloadByIdIfExists(id);
  }
}
