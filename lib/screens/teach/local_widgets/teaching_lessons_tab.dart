import 'package:courseplease/screens/teach/local_widgets/teaching_lessons_resolved_tab.dart';
import 'package:courseplease/screens/teach/local_widgets/teaching_lessons_to_schedule_tab.dart';
import 'package:courseplease/screens/teach/local_widgets/teaching_lessons_upcoming_tab.dart';
import 'package:courseplease/screens/teach/local_widgets/teachnig_lessons_awaiting_approval_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TeachingLessonsTabWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: [
              // TODO: Add counts.
              Tab(text: tr('TeachingLessonsTabWidget.toSchedule')),
              Tab(text: tr('TeachingLessonsTabWidget.upcoming')),
              Tab(text: tr('TeachingLessonsTabWidget.awaitingApproval')),
              Tab(text: tr('TeachingLessonsTabWidget.resolved')),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                TeachingLessonsToScheduleTabWidget(),
                TeachingLessonsUpcomingTabWidget(),
                TeachingLessonsAwaitingApprovalTabWidget(),
                TeachingLessonsResolvedTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
