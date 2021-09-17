import 'package:flutter/widgets.dart';

class FramedColumn extends StatelessWidget {
  final List<Widget> children;

  FramedColumn({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
