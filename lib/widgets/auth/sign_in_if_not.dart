import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/widgets/auth/authenticated_or_not.dart';
import 'package:courseplease/widgets/auth/sign_in_centered.dart';
import 'package:courseplease/widgets/builders/abstract.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class SignInIfNotWidget extends StatelessWidget {
  final ValueFinalWidgetBuilder<AuthenticationState> signedInBuilder;
  final String? titleText;

  SignInIfNotWidget({
    required this.signedInBuilder,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return AuthenticatedOrNotWidget(
      authenticatedBuilder: signedInBuilder,
      notAuthenticatedBuilder: _buildNotAuthenticated,
      progressBuilder: _buildProgress,
    );
  }

  Widget _buildNotAuthenticated(BuildContext context, AuthenticationState state) {
    return SignInCenteredWidget(titleText: titleText);
  }

  Widget _buildProgress(BuildContext context, AuthenticationState state) {
    return SmallCircularProgressIndicator();
  }
}
