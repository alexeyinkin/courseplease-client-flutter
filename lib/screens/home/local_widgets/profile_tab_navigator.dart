import 'package:courseplease/router/abstract_tab_state.dart';
import 'package:courseplease/screens/home/local_widgets/profile_tab.dart';
import 'package:flutter/material.dart';

class ProfileTabNavigator extends StatelessWidget {
  final AbstractTabState state;

  ProfileTabNavigator({
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
          child: ProfileTab(),
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
