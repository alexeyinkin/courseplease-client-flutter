import 'package:courseplease/widgets/auth/authenticated_or_not.dart';
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
    return AuthenticatedOrNotWidget(
      authenticatedBuilder: (_) => _buildAuthenticated(),
      notAuthenticatedBuilder: (_) => Text("Not Authenticated"), // TODO: Make a widget
    );
  }

  Widget _buildAuthenticated() {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: tr('LearningLessonsTabWidget.title')),
            ],
          ),
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
