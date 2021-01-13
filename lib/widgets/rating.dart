import 'package:charcode/html_entity.dart';
import 'package:courseplease/models/rating.dart';
import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final Rating rating;
  final int scale;

  RatingWidget({@required this.rating, this.scale = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 4),
          child: Icon(
            rating.voteCount > 0 ? Icons.star : Icons.star_border,
            color: rating.voteCount > 0 ? Colors.amber : Colors.grey,
          ),
        ),
        Text(
          rating.voteCount > 0 ? (rating.rating * scale).toStringAsFixed(2) : String.fromCharCode($mdash),
        ),
      ],
    );
  }
}
