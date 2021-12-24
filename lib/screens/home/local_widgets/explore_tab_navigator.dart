import 'package:courseplease/router/explore_tab_state.dart';
import 'package:courseplease/screens/home/local_widgets/explore_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExploreTabNavigator extends StatelessWidget {
  final ExploreTabState state;

  ExploreTabNavigator({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
          child: ExploreTabWidget(
            state: state,
          ),
        ),
        ...state.pages,
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        return true;
      },
    );
  }
}
