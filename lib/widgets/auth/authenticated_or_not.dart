import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class AuthenticatedOrNotWidget extends StatefulWidget {
  final ValueFinalWidgetBuilder<AuthenticationState> authenticatedBuilder;
  final ValueFinalWidgetBuilder<AuthenticationState> notAuthenticatedBuilder;
  final ValueFinalWidgetBuilder<AuthenticationState>? progressBuilder;
  final ValueFinalWidgetBuilder<AuthenticationState>? failedBuilder;

  AuthenticatedOrNotWidget({
    required this.authenticatedBuilder,
    required this.notAuthenticatedBuilder,
    this.progressBuilder,
    this.failedBuilder,
  });

  @override
  State<AuthenticatedOrNotWidget> createState() => AuthenticatedOrNotWidgetState();
}

class AuthenticatedOrNotWidgetState extends State<AuthenticatedOrNotWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthenticationState>(
      stream: _authenticationCubit.outState,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? _authenticationCubit.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, AuthenticationState state) {
    switch (state.status) {
      case AuthenticationStatus.authenticated:
        return _buildAuthenticated(context, state);

      case AuthenticationStatus.deviceKey:
        return _buildNotAuthenticated(context, state);

      case AuthenticationStatus.notLoadedFromStorage:
      case AuthenticationStatus.fresh:
      case AuthenticationStatus.requested:
        return _buildProgress(context, state);

      case AuthenticationStatus.deviceKeyFailed:
        return _buildFailed(context, state);
    }
  }

  Widget _buildAuthenticated(BuildContext context, AuthenticationState state) {
    return widget.authenticatedBuilder(context, state);
  }

  Widget _buildNotAuthenticated(BuildContext context, AuthenticationState state) {
    return widget.notAuthenticatedBuilder(context, state);
  }

  Widget _buildProgress(BuildContext context, AuthenticationState state) {
    return (widget.progressBuilder ?? widget.notAuthenticatedBuilder)(context, state);
  }

  Widget _buildFailed(BuildContext context, AuthenticationState state) {
    return (widget.failedBuilder ?? widget.notAuthenticatedBuilder)(context, state);
  }
}
