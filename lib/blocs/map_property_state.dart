import 'package:courseplease/models/map_property.dart';
import 'package:flutter/widgets.dart';

class MapPropertyState {
  final MapProperty property;
  final TextEditingController textEditingController;

  MapPropertyState({
    required this.property,
    required this.textEditingController,
  });
}
