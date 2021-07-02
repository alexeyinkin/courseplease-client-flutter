import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Copied from https://pub.dev/packages/flag
class AppFlag extends StatelessWidget {
  final String country;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget replacement;

  AppFlag(
    this.country, {
    Key? key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.replacement = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String countryName = country.toLowerCase();

    return SvgPicture.asset(
      'assets/flags/$countryName.svg',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
