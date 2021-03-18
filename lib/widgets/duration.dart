import 'package:courseplease/utils/utils.dart';
import 'package:flutter/material.dart';

class DurationWidget extends StatelessWidget {
  final Duration duration;

  DurationWidget({
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Color(0x80000000),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(formatDuration(duration)),
    );
  }
}
