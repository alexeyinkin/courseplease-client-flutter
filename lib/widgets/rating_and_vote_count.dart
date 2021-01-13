import 'package:courseplease/models/rating.dart';
import 'package:flutter/material.dart';
import 'rating.dart';
import 'user_count.dart';

class RatingAndVoteCountWidget extends StatelessWidget {
  final Rating rating;
  final bool hideIfEmpty;

  RatingAndVoteCountWidget({
    @required this.rating,
    this.hideIfEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    if (rating.voteCount == 0 && hideIfEmpty) return Row(children: []);

    return Wrap(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: RatingWidget(rating: rating),
        ),
        UserCountWidget(rating.voteCount),
      ],
    );
  }
}
