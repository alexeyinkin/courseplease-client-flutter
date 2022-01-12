import 'package:app_state/app_state.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/explore/page.dart';

class PageFactory {
  static AbstractPage<ScreenConfiguration>? createPage(
    String key,
    Map<String, dynamic> state,
  ) {
    switch (key) {
      case ExplorePage.factoryKey: return ExplorePage();
    }

    return null;
  }
}
