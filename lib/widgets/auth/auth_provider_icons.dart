import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:flutter/widgets.dart';

class AuthProviderIconsWidget extends StatelessWidget {
  final List<AuthProvider> providers;
  final Widget? leadingIfNotEmpty;
  final double scale;
  final ValueChanged<AuthProvider> onTap;

  AuthProviderIconsWidget({
    required this.providers,
    this.leadingIfNotEmpty,
    this.scale = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (providers.isEmpty) return Container();

    final children = <Widget>[];

    if (leadingIfNotEmpty != null) children.add(leadingIfNotEmpty!);

    for (final provider in providers) {
      children.add(
        GestureDetector(
          onTap: () => onTap(provider),
          child: AuthProviderIcon(
            name: provider.intName,
            scale: scale,
          ),
        ),
      );
    }

    return Wrap(
      children: children,
      spacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
    );
  }
}
