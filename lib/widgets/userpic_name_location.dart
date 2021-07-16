import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/screens/teacher/teacher.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/teacher_rating_and_customer_count.dart';
import 'package:courseplease/widgets/user.dart';
import 'package:flutter/material.dart';

class UserpicNameLocationWidget extends StatelessWidget {
  final Teacher teacher;
  UserpicNameLocationWidget({
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UserpicWidget(user: teacher, size: 50),
              SmallPadding(),
              TeacherRatingAndCustomerCountWidget(teacher: teacher),
            ],
          ),
          SmallPadding(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(teacher.firstName + ' ' + teacher.lastName + ' ' + teacher.id.toString(), style: TextStyle(fontWeight: FontWeight.bold))
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: LocationLineWidget(location: teacher.location, textOpacity: .5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onTap(BuildContext context) {
    TeacherScreen.show(
      context: context,
      teacherId: teacher.id,
    );
  }
}
