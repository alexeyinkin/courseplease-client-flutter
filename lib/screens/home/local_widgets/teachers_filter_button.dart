import 'package:courseplease/models/filters/teacher.dart';
import 'package:courseplease/screens/explore/local_blocs/teachers_tab.dart';
import 'package:courseplease/screens/filter/local_blocs/teacher_filter.dart';
import 'package:courseplease/screens/filter/local_widgets/teacher_filter.dart';
import 'package:courseplease/services/filter_buttons/teacher_filter.dart';
import 'package:courseplease/widgets/filter_button.dart';
import 'package:flutter/material.dart';

class TeachersFilterButton extends StatelessWidget {
  final TeachersTabCubit cubit;

  TeachersFilterButton({
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return FilterButton<TeacherFilter, TeacherFilterDialogCubit>(
      filterableCubit: cubit,
      filterButtonService: TeacherFilterButtonService(),
      dialogContentCubitFactory: () => TeacherFilterDialogCubit(),
      dialogContentBuilder: (context, cubit) => TeacherFilterDialogContentWidget(cubit: cubit),
      style: FilterButtonStyle.flat,
    );
  }
}
