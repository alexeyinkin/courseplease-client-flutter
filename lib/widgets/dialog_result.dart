import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:flutter/widgets.dart';

@Deprecated('Use app_state package events for screen management and pop-ups')
class DialogResult {
  final DialogResultCode code;

  DialogResult({
    required this.code,
  });
}

@Deprecated('Use app_state package events for screen management and pop-ups')
enum DialogResultCode {
  ok,
  error,
}

@Deprecated('Use app_state package events for screen management and pop-ups')
void showErrorIfShould(BuildContext context, DialogResult result) {
  switch (result.code) {
    case DialogResultCode.error:
      ErrorPopupScreen.show(context: context);
      break;
    default: // Nothing.
  }
}
