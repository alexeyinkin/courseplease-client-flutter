import 'package:courseplease/blocs/screen.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/router/app_configuration.dart';

import 'local_blocs/lesson_list_action.dart';
import 'configurations.dart';

class MyLessonListBloc extends AppScreenBloc<void> {
  final MyLessonFilter filter;

  final SelectableListCubit<int, MyLessonFilter> selectableListCubit;
  final LessonListActionCubit listActionCubit;

  MyLessonListBloc({
    required this.filter,
  }) :
      selectableListCubit = SelectableListCubit<int, MyLessonFilter>(initialFilter: filter),
      listActionCubit = LessonListActionCubit(filter: filter)
  ;

  @override
  void createState() {}

  @override
  AppConfiguration get currentConfiguration {
    return MyLessonListConfiguration(filter: filter);
  }
}
