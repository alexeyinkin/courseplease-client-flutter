import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:get_it/get_it.dart';

import '../model_cache_factory.dart';

class ImageReloadService {
  void reload(int id) {
    final cache = GetIt.instance.get<ModelCacheCache>().getOrCreate<int, ImageEntity, GalleryImageRepository>();
    cache.reloadByIdIfExists(id);
  }
}
