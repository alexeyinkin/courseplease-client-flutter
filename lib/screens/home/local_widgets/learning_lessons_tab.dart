import 'package:courseplease/screens/home/local_widgets/learning_lessons_resolved_tab.dart';
import 'package:courseplease/screens/home/local_widgets/learning_lessons_to_schedule_tab.dart';
import 'package:courseplease/screens/home/local_widgets/learning_lessons_upcoming_tab.dart';
import 'package:courseplease/screens/home/local_widgets/learning_lessons_to_approve_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LearningLessonsTabWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            tabs: [
              // TODO: Add counts.
              Tab(text: tr('LearningLessonsTabWidget.toSchedule')),
              Tab(text: tr('LearningLessonsTabWidget.upcoming')),
              Tab(text: tr('LearningLessonsTabWidget.toApprove')),
              Tab(text: tr('LearningLessonsTabWidget.resolved')),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                LearningLessonsToScheduleTabWidget(),
                LearningLessonsUpcomingTabWidget(),
                LearningLessonsToApproveTabWidget(),
                LearningLessonsResolvedTabWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
