import 'package:flutter/material.dart';
import 'package:model_interfaces/model_interfaces.dart';

import '../pad.dart';

class IdErrorWidget extends StatelessWidget {
  final WithId object;

  IdErrorWidget({
    required this.object,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.error),
        SmallPadding(),
        Text(object.id.toString()),
      ],
    );
  }
}
