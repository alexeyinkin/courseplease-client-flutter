import 'package:courseplease/models/auth/auth_provider.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthProviderWidget extends StatelessWidget {
  final AuthProvider provider;
  final String titleTemplate;
  final VoidCallback onTap; // Nullable

  AuthProviderWidget({
    @required this.provider,
    this.titleTemplate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Color(0x40808080),
          border: Border.all(
            color: Color(0xFF808080),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            //Image(image: AssetImage('assets/auth_providers/' + provider.intName + '.svg')),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 25),
              child: SvgPicture.asset(
                'assets/auth_providers/' + provider.intName + '.svg',
                width: 36,
              ),
            ),
            Text(
              _getButtonTitle(),
              style: AppStyle.h3,
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonTitle() {
    if (titleTemplate == null) return provider.title;
    return titleTemplate.replaceFirst('{@title}', provider.title);
  }
}
