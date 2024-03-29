import 'dart:async';

import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/my_profile/configurations.dart';
import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/services/auth/auth_providers.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class MyProfileBloc extends AppPageStatefulBloc<MyProfileCubitState> {
  late final MyProfileCubitState initialState;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late final StreamSubscription _authenticationSubscription;

  late AuthenticationState _authenticationState;
  bool _connectAccountsExpanded = false;

  MyProfileBloc() {
    _authenticationState = _authenticationCubit.initialState;
    initialState = createState();
    _authenticationSubscription = _authenticationCubit.outState.listen(_onAuthenticationStateChanged);
  }

  void _onAuthenticationStateChanged(AuthenticationState state) {
    _authenticationState = state;
    emitState();
  }

  @override
  MyProfileCubitState createState() {
    final connectedAccounts = _authenticationState.data?.contacts ?? <EditableContact>[];
    final allProviders = AuthProviders.connectProviders;

    final connectedIntNames = <String, void>{};

    for (final contact in _authenticationState.data?.contacts ?? <EditableContact>[]) {
      connectedIntNames[contact.className] = true;
    }

    final suggestedProviders = <AuthProvider>[];
    final otherProviders = <AuthProvider>[];

    for (final provider in allProviders) {
      if (connectedIntNames.containsKey(provider.intName)) {
        otherProviders.add(provider);
      } else {
        suggestedProviders.add(provider);
      }
    }

    return MyProfileCubitState(
      meResponseData: _authenticationState.data,
      connectedAccounts: connectedAccounts,
      suggestedAuthProviders: suggestedProviders,
      otherAuthProviders: otherProviders,
      connectAccountsExpanded: _connectAccountsExpanded,
    );
  }

  @override
  MyPageConfiguration getConfiguration() {
    return MyProfileConfiguration();
  }

  Future<void> reloadCurrentActor() {
    return _authenticationCubit.reloadCurrentActor();
  }

  void requestAuthorization(BuildContext context, AuthProvider provider) {
    _authenticationCubit.requestAuthorization(context, provider);
  }

  void toggleMore() {
    _connectAccountsExpanded = !_connectAccountsExpanded;
    emitState();
  }

  @override
  void dispose() {
    _authenticationSubscription.cancel();
    super.dispose();
  }
}

class MyProfileCubitState {
  final MeResponseData? meResponseData;
  final List<EditableContact> connectedAccounts;
  final List<AuthProvider> suggestedAuthProviders;
  final List<AuthProvider> otherAuthProviders;
  final bool connectAccountsExpanded;

  MyProfileCubitState({
    required this.meResponseData,
    required this.connectedAccounts,
    required this.suggestedAuthProviders,
    required this.otherAuthProviders,
    required this.connectAccountsExpanded,
  });
}
