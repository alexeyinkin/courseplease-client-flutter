import 'package:courseplease/widgets/auth/sign_in_if_not.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'learning_lessons_tab.dart';

class LearningTabWidget extends StatefulWidget {
  @override
  _LearningTabWidgetState createState() => _LearningTabWidgetState();
}

class _LearningTabWidgetState extends State<LearningTabWidget> {
  @override
  Widget build(BuildContext context) {
    return SignInIfNotWidget(
      signedInBuilder: (_, __) => _buildAuthenticated(),
      titleText: tr('LearningTabWidget.unauthenticatedTitle'),
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
          //     Tab(text: tr('LearningLessonsTabWidget.title')),
          //   ],
          // ),
          Expanded(
            child: TabBarView(
              children: [
                LearningLessonsTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
