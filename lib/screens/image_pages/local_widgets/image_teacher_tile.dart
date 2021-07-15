import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/teacher_rating_and_customer_count.dart';
import 'package:flutter/material.dart';

class ImageTeacherTile extends StatelessWidget {
  final Teacher teacher;
  ImageTeacherTile({
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final relativeUrl = teacher.userpicUrls['300x300'] ?? null;
    final url = relativeUrl == null ? null : 'https://courseplease.com' + relativeUrl;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: url == null ? null : NetworkImage(url),
                ),
              ),
              TeacherRatingAndCustomerCountWidget(teacher: teacher),
            ],
          ),
        ),
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
    );
  }
}
