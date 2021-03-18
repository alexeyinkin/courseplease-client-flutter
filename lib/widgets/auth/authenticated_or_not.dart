import 'package:courseplease/blocs/authentication.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class AuthenticatedOrNotWidget extends StatefulWidget {
  final WidgetBuilder authenticatedBuilder;
  final WidgetBuilder notAuthenticatedBuilder;

  AuthenticatedOrNotWidget({
    required this.authenticatedBuilder,
    required this.notAuthenticatedBuilder,
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
    return state.status == AuthenticationStatus.authenticated
        ? _buildAuthenticated(context, state)
        : _buildNotAuthenticated(context, state);
  }

  Widget _buildAuthenticated(BuildContext context, AuthenticationState state) {
    return widget.authenticatedBuilder(context);
  }

  Widget _buildNotAuthenticated(BuildContext context, AuthenticationState state) {
    return widget.notAuthenticatedBuilder(context);
  }
}
