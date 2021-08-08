import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/blocs/list_action/move_list_action.dart';
import 'package:courseplease/blocs/list_action/unlink_list_action.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/repositories/my_lesson.dart';

class LessonListActionCubit extends MediaSortListActionCubit<int, Lesson, MyLessonFilter, MyLessonRepository>
    with
        MoveListActionMixin<int, MyLessonFilter>,
        UnlinkListActionMixin<int, MyLessonFilter>
{
  static const _mediaType = 'lesson';

  LessonListActionCubit({
    required MyLessonFilter filter,
  }) : super (
    filter: filter,
  );

  @override
  String getMediaType() {
    return _mediaType;
  }
}
