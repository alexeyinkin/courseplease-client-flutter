import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/auth/auth_provider.dart';
import 'package:courseplease/widgets/auth/auth_providers.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

// State is required to use context to navigate to the auth URI.
class SignInWidget extends StatefulWidget {
  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Container(
            child: _buildProviderList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderList() {
    return StreamBuilder<List<AuthProvider>>(
      stream: _authenticationCubit.outProviders,
      builder: (context, snapshot) => _buildProviderListWithState(snapshot.data),
    );
  }

  Widget _buildProviderListWithState(List<AuthProvider>? authProviders) {
    return authProviders == null
        ? SmallCircularProgressIndicator()
        : _buildProviderListWithList(authProviders);
  }

  Widget _buildProviderListWithList(List<AuthProvider> authProviders) {
    return AuthProvidersWidget(
      providers: authProviders,
      titleTemplate: tr('SignInWidget.continueWith'),
      onTap: _signInWith,
    );
  }

  void _signInWith(AuthProvider provider) async {
    _authenticationCubit.requestAuthorization(provider, context);
  }
}
