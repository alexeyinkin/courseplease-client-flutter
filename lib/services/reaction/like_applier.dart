import 'package:courseplease/blocs/like.dart';
import 'package:courseplease/models/reaction/likable.dart';

/// Applies like and delike actions to an object to show after the action
/// happened and before the object is reloaded from server.
class LikeApplierService {
  Likable applyActions(Likable obj, ObjectLikeActions actions) {
    for (final entry in actions.actions.entries) {
      final timestamp = entry.key;
      if (timestamp < obj.loadTimestampMilliseconds) continue;

      obj = _applyAction(obj, timestamp, entry.value);
    }

    return obj;
  }

  Likable _applyAction(Likable obj, int timestamp, LikeAction action) {
    switch (action) {
      case LikeAction.createLike:
        return Likable(
          id: obj.id,
          likeCount: obj.likeCount + (obj.isLiked ? 0 : 1),
          isLiked: true,
          loadTimestampMilliseconds: timestamp,
        );
      case LikeAction.deleteLike:
        return Likable(
          id: obj.id,
          likeCount: obj.likeCount - (obj.isLiked ? 1 : 0),
          isLiked: false,
          loadTimestampMilliseconds: timestamp,
        );
    }
    throw Exception('Unknown LikeAction: ' + action.toString());
  }
}
