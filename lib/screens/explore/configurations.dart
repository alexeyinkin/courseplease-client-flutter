import 'package:courseplease/models/interfaces/with_homogenous_parent_intname.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/explore/explore_tab_enum.dart';
import 'package:flutter/widgets.dart';

class ExploreRootConfiguration extends AppConfiguration {
  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/explore');
  }
}

class ExploreSubjectConfiguration extends AppConfiguration {
  final ExploreTab tab;
  final ProductSubject productSubject;

  ExploreSubjectConfiguration({
    required this.tab,
    required this.productSubject,
  });

  @override
  RouteInformation restoreRouteInformation() {
    return RouteInformation(location: '/explore/${productSubject.slashedPath}/${tab.name}');
  }
}
