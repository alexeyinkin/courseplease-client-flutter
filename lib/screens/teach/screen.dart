import 'package:courseplease/screens/teach/local_widgets/teaching_lessons_tab.dart';
import 'package:courseplease/widgets/auth/sign_in_if_not.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TeachScreen extends StatelessWidget {
  const TeachScreen();

  @override
  Widget build(BuildContext context) {
    return SignInIfNotWidget(
      signedInBuilder: (_, __) => _buildAuthenticated(),
      titleText: tr('TeachingTabWidget.unauthenticatedTitle'),
    );
  }

  Widget _buildAuthenticated() {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: [
          // Uncomment this when courses are introduced.
          // TabBar(
          //   tabs: [
          //     Tab(text: tr('TeachingLessonsTabWidget.title')),
          //   ],
          // ),
          Expanded(
            child: TabBarView(
              children: [
                TeachingLessonsTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
