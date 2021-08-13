import 'package:courseplease/models/location.dart';
import 'package:courseplease/widgets/flag_icon.dart';
import 'package:flutter/material.dart';
import 'subway_station.dart';

class LocationLineWidget extends StatelessWidget {
  final Location location;
  final double textOpacity;

  LocationLineWidget({
    required this.location,
    this.textOpacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (location.countryCode == '') return Container();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(right: 4),
                child: FlagIcon(countryCode: location.countryCode),
              ),
              Opacity(
                opacity: textOpacity,
                child: Text(location.publicLine),
              ),
            ],
          ),
        ),
        ..._getSubwayStationWidgets(),
      ],
    );
  }

  List<Widget> _getSubwayStationWidgets() {
    final result = <Widget>[];

    for (final subwayStation in location.subwayStations) {
      result.add(
        SubwayStationWidget(
          subwayStation: subwayStation,
          textOpacity: textOpacity,
        ),
      );
    }

    return result;
  }
}
