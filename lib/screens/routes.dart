import 'edit_image_list/edit_image_list.dart';
import 'edit_integration/edit_integration.dart';
import 'edit_profile/edit_profile.dart';
import 'edit_teacher_subject/edit_teacher_subject.dart';
import 'edit_teaching/edit_teaching.dart';
import 'image/image.dart';
import 'lesson/lesson.dart';
import 'select_product_subject/select_product_subject.dart';
import 'sign_in_webview/sign_in_webview.dart';
import 'teacher/teacher.dart';

final routeBuilders = {
  EditImageLightboxScreen.routeName:        (context) => EditImageLightboxScreen(),
  EditImageListScreen.routeName:            (context) => EditImageListScreen(),
  EditIntegrationScreen.routeName:          (context) => EditIntegrationScreen(),
  EditProfileScreen.routeName:              (context) => EditProfileScreen(),
  EditTeacherSubjectScreen.routeName:       (context) => EditTeacherSubjectScreen(),
  EditTeachingScreen.routeName:             (context) => EditTeachingScreen(),
  FixedIdsImageLightboxScreen.routeName:    (context) => FixedIdsImageLightboxScreen(),
  LessonScreen.routeName:                   (context) => LessonScreen(),
  SelectProductSubjectScreen.routeName:     (context) => SelectProductSubjectScreen(),
  SignInWebviewScreen.routeName:            (context) => SignInWebviewScreen(),
  TeacherScreen.routeName:                  (context) => TeacherScreen(),
  ViewImageLightboxScreen.routeName:        (context) => ViewImageLightboxScreen(),
};
