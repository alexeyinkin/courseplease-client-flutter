import 'package:courseplease/models/rating.dart';
import 'package:courseplease/models/teacher.dart';
import 'package:courseplease/widgets/rating_and_vote_count.dart';
import 'package:flutter/widgets.dart';

class TeacherRatingAndCustomerCountWidget extends StatelessWidget {
  final Teacher teacher;

  TeacherRatingAndCustomerCountWidget({
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final rating = Rating(
      rating: teacher.rating.rating,
      voteCount: teacher.customerCount,
    );

    return RatingAndVoteCountWidget(rating: rating);
  }
}
