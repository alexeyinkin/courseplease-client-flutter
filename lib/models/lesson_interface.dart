import 'interfaces.dart';

abstract class LessonInterface extends WithId<int> {
  int get id;
  String? get coverUrl;
  int get durationSeconds;
  String get type;
}
