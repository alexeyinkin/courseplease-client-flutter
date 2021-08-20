import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/services/auth/auth_providers.dart';
import 'package:courseplease/widgets/auth/auth_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class SignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: AuthProvidersWidget(
        providers: AuthProviders.signUpProviders,
        titleTemplate: tr('SignInWidget.continueWith'),
        onTap: (provider) => _signInWith(context, provider),
      ),
    );
  }

  void _signInWith(BuildContext context, AuthProvider provider) async {
    final authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
    authenticationCubit.requestAuthorization(context, provider);
  }
}
