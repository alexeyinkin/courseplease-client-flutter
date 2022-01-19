import 'package:app_state/app_state.dart';

class SnackEvent extends PageBlocEvent {
  final SnackEventType type;
  final String message;

  SnackEvent({
    required this.type,
    required this.message,
  });
}

enum SnackEventType {
  info,
  error,
}
