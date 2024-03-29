import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'auth_provider.dart';

class AuthProvidersWidget extends StatelessWidget {
  final List<AuthProvider> providers;
  final String titleTemplate;
  final ValueChanged<AuthProvider> onTap;

  AuthProvidersWidget({
    required this.providers,
    required this.titleTemplate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final provider in providers) {
      children.add(
        AuthProviderWidget(
          provider: provider,
          titleTemplate: titleTemplate,
          onTap: () => _handleTap(provider),
        ),
      );
    }

    return Wrap(
      direction: Axis.vertical,
      spacing: 10,
      children: children,
    );
  }

  void _handleTap(AuthProvider provider) {
    onTap(provider);
  }
}
