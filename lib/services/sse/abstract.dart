import 'package:courseplease/models/sse/server_sent_event.dart';

abstract class AbstractSseListener {
  void onEvent(ServerSentEvent event);
}

class EmptySseListener extends AbstractSseListener {
  @override
  void onEvent(ServerSentEvent event) {}
}

abstract class AbstractSseReloader {
  /// Called when its too much server sent events and the app should
  /// reload everything that can potentially come via SSE.
  void reload();
}
