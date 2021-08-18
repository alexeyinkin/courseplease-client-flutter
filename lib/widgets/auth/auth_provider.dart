import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'auth_provider_icon.dart';

class AuthProviderWidget extends StatelessWidget {
  final AuthProvider provider;
  final String? titleTemplate;
  final VoidCallback? onTap;

  AuthProviderWidget({
    required this.provider,
    required this.titleTemplate,
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
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 25),
              child: AuthProviderIcon(name: provider.intName),
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
    return titleTemplate!.replaceFirst('{@providerTitle}', provider.title);
  }
}
