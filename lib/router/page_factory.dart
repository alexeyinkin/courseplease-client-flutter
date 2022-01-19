import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/create_lesson/page.dart';
import 'package:courseplease/screens/edit_lesson/page.dart';
import 'package:courseplease/screens/edit_profile/page.dart';
import 'package:courseplease/screens/edit_teaching/page.dart';
import 'package:courseplease/screens/explore/page.dart';
import 'package:courseplease/screens/image/page.dart';
import 'package:courseplease/screens/learn/page.dart';
import 'package:courseplease/screens/lesson/page.dart';
import 'package:courseplease/screens/messages/page.dart';
import 'package:courseplease/screens/my_lesson_list/page.dart';
import 'package:courseplease/screens/my_profile/page.dart';
import 'package:courseplease/screens/teach/page.dart';
import 'package:courseplease/screens/teacher/page.dart';

class PageFactory {
  static AbstractPage<MyPageConfiguration>? createPage(
    String key,
    Map<String, dynamic> state,
  ) {
    switch (key) {
      case CreateLessonPage.factoryKey: return CreateLessonPage(subjectId: state['subjectId']);
      case EditLessonPage.factoryKey:   return EditLessonPage(lessonId: state['lessonId']);
      case EditProfilePage.factoryKey:  return EditProfilePage();
      case EditTeachingPage.factoryKey: return EditTeachingPage();
      case ExplorePage.factoryKey:      return ExplorePage();
      case ImagePage.factoryKey:        return ImagePage(imageId: state['imageId'], subjectPath: state['subjectPath']);
      case LearnPage.factoryKey:        return LearnPage();
      case LessonPage.factoryKey:       return LessonPage(lessonId: state['lessonId']);
      case MessagesPage.factoryKey:     return MessagesPage();
      case MyLessonListPage.factoryKey: return MyLessonListPage(subjectId: state['subjectId']);
      case MyProfilePage.factoryKey:    return MyProfilePage();
      case TeachPage.factoryKey:        return TeachPage();
      case TeacherPage.factoryKey:      return TeacherPage(teacherId: state['teacherId']);
    }

    return null;
  }
}
