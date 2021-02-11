import 'package:flutter/material.dart';

class ImageOverlay extends StatelessWidget {
  final Widget child;

  ImageOverlay({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: getBorderRadius(),
        color: Color(0x60000000),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
        ),
        child: child,
      ),
    );
  }

  @protected
  BorderRadius getBorderRadius() => null; // Nullable.
}

class RoundedOverlay extends ImageOverlay {
  RoundedOverlay({
    @required Widget child,
  }) : super (
    child: child,
  );

  @override
  BorderRadius getBorderRadius() => BorderRadius.circular(10);
}
