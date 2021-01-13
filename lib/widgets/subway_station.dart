import 'package:courseplease/models/subway_station.dart';
import 'package:flutter/material.dart';

class SubwayStationWidget extends StatelessWidget {
  final SubwayStation subwayStation;
  final double textOpacity;

  SubwayStationWidget({
    @required this.subwayStation,
    this.textOpacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(right: 4),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Color(subwayStation.color | 0xFF000000),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Opacity(
          opacity: textOpacity,
          child: Text(subwayStation.title),
        ),
      ],
    );
  }
}
