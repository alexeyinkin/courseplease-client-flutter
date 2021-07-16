import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/models/reaction/comment.dart';
import 'package:courseplease/repositories/comment.dart';
import 'package:get_it/get_it.dart';

import '../filtered_model_list_factory.dart';
import '../model_cache_factory.dart';

class CommentReloadService {

  void delete(int id) {
    _deleteFromLists(id);
    _deleteFromCache(id);
  }

  void _deleteFromLists(int id) {
    final cache = GetIt.instance.get<FilteredModelListCache>();
    final lists = cache.getModelListsByObjectAndFilterTypes<int, Comment, CommentFilter>();

    for (final list in lists.values) {
      list.removeObjectIds([id]);
    }
  }

  void _deleteFromCache(int id) {
    final cache = GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Comment, CommentRepository>();
    cache.reloadByIdIfExists(id);
  }
}
