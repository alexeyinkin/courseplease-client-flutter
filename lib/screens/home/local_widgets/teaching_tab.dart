import 'package:courseplease/screens/home/local_widgets/teaching_lessons_tab.dart';
import 'package:courseplease/widgets/auth/authenticated_or_not.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TeachingTabWidget extends StatefulWidget {
  @override
  _TeachingTabWidgetState createState() => _TeachingTabWidgetState();
}

class _TeachingTabWidgetState extends State<TeachingTabWidget> {
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
