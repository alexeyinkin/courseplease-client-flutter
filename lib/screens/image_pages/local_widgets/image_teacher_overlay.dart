import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/widgets/overlay.dart';
import 'package:courseplease/widgets/builders/models/teacher.dart';
import 'package:courseplease/widgets/toggle_overlay.dart';
import 'package:flutter/material.dart';

import '../../../widgets/userpic_name_location.dart';

class ImageTeacherOverlay extends StatelessWidget {
  final int teacherId;
  final bool visible;

  ImageTeacherOverlay({
    required this.teacherId,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return TeacherBuilderWidget(
      id: teacherId,
      builder: _buildWithTeacher,
    );
  }

  Widget _buildWithTeacher(BuildContext context, Teacher teacher) {
    return Positioned(
      left: 10,
      bottom: 10,
      child: ToggleOverlay(
        visible: visible,
        child: RoundedOverlay(
          child: UserpicNameLocationWidget(teacher: teacher),
        ),
      ),
    );
  }
}
