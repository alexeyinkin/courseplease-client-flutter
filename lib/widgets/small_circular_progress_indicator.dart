import 'package:flutter/material.dart';

class SmallCircularProgressIndicator extends StatelessWidget {
  final double scale;

  SmallCircularProgressIndicator({
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 30 * scale,
        height: 30 * scale,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xC0808080)),
        ),
      ),
    );
  }
}
