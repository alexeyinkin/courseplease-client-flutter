import 'package:charcode/html_entity.dart';
import 'package:courseplease/models/rating.dart';
import 'package:flutter/material.dart';

class SingleStarRatingWidget extends StatelessWidget {
  final Rating rating;
  final int scale;
  final int precision;

  SingleStarRatingWidget({
    required this.rating,
    this.scale = defaultScale,
    this.precision = 0,
  });

  static const defaultScale = 5;

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
          rating.voteCount > 0 ? (rating.rating * scale).toStringAsFixed(precision) : String.fromCharCode($mdash),
        ),
      ],
    );
  }
}
