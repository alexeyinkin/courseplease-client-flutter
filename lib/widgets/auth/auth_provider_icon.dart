import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class AuthProviderIcon extends StatelessWidget {
  final String name;
  final double scale;

  AuthProviderIcon({
    required this.name,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/auth_providers/' + name + '.svg',
      width: 36 * scale,
    );
  }
}
