import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/edit_teaching/configurations.dart';

class EditTeachingBloc extends AppPageBloc {
  @override
  MyPageConfiguration? getConfiguration() => const EditTeachingConfiguration();
}
