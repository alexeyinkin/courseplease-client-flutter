import 'package:model_interfaces/model_interfaces.dart';

abstract class LessonInterface extends WithId<int> {
  int get id;
  String? get coverUrl;
  int get durationSeconds;
  String get type;
  String get title;
  String get body;
  String get lang;
}
