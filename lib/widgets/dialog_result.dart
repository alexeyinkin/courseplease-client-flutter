import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:flutter/widgets.dart';

class DialogResult {
  final DialogResultCode code;

  DialogResult({
    required this.code,
  });
}

enum DialogResultCode {
  ok,
  error,
}

void popOrShowError(BuildContext context, DialogResult result) {
  switch (result.code) {
    case DialogResultCode.ok:
      Navigator.of(context).pop(result);
      break;
    case DialogResultCode.error:
      ErrorPopupScreen.show(context: context);
      break;
  }
}

void showErrorIfShould(BuildContext context, DialogResult result) {
  switch (result.code) {
    case DialogResultCode.error:
      ErrorPopupScreen.show(context: context);
      break;
    default: // Nothing.
  }
}
