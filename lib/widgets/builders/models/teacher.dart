import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/widgets/builders/models/abstract.dart';
import 'package:flutter/widgets.dart';

import '../abstract.dart';

class TeacherBuilderWidget extends StatelessWidget {
  final int id;
  final ValueFinalWidgetBuilder<Teacher> builder;

  TeacherBuilderWidget({
    required this.id,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ModelBuilderWidget<int, Teacher, TeacherRepository>(id: id, builder: builder);
  }
}
