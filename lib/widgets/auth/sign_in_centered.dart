import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/auth/sign_in.dart';
import 'package:flutter/widgets.dart';

class SignInCenteredWidget extends StatelessWidget {
  final String? titleText;

  SignInCenteredWidget({
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titleText != null) _getTitleWidget(),
          SignInWidget(),
        ],
      ),
    );
  }

  Widget _getTitleWidget() {
    return Text(
      titleText ?? '',
      style: AppStyle.h3,
    );
  }
}
