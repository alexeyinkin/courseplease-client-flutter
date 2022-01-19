import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/explore/configurations.dart';
import 'package:courseplease/screens/explore/explore_tab_enum.dart';
import 'package:flutter/widgets.dart';

import 'page.dart';

// Avoiding name clash with ImageConfiguration of flutter/painting.
class ImagePageConfiguration extends MyPageConfiguration {
  final int imageId;
  final String subjectPath;

  ImagePageConfiguration({
    required this.imageId,
    required this.subjectPath,
  }) : super(
    key: ImagePage.formatKey(imageId: imageId),
    factoryKey: ImagePage.factoryKey,
    state: {'imageId': imageId, 'subjectPath': subjectPath},
  );

  static final _regExp = RegExp(r'^/explore/(.*)/images/(\d+)/comments$');

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(
      location: '/explore/$subjectPath/images/$imageId/comments',
    );
  }

  static ImagePageConfiguration? tryParse(RouteInformation ri) {
    final matches = _regExp.firstMatch(ri.location ?? '');
    if (matches == null) return null;

    final subjectPath = matches[1];
    final imageId = int.tryParse(matches[2] ?? '');

    if (subjectPath == null || imageId == null) {
      return null; // TODO: Log error
    }

    return ImagePageConfiguration(
      imageId: imageId,
      subjectPath: subjectPath,
    );
  }

  @override
  AppNormalizedState get defaultAppNormalizedState {
    return AppNormalizedState(
      homeTab: HomeTab.explore,
      appConfiguration: AppConfiguration.singleStack(
        key: HomeTab.explore.name,
        pageConfigurations: [
          ExploreSubjectConfiguration(tab: ExploreTab.images, subjectPath: subjectPath),
          this,
        ],
      ),
    );
  }
}
