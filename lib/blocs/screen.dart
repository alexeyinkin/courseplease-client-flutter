import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/router/snack_event.dart';
import 'package:easy_localization/easy_localization.dart';

abstract class AppScreenBloc<S> extends ScreenBloc<AppConfiguration, S> {
  void emitDone() {
    emitEvent(SnackEvent(type: SnackEventType.info, message: tr('common.done')));
  }

  void emitSaved() {
    emitEvent(SnackEvent(type: SnackEventType.info, message: tr('common.saved')));
  }

  void emitUnknownError() {
    emitEvent(SnackEvent(type: SnackEventType.error, message: tr('errors.unknown')));
  }
}
