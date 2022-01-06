import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/messages/configurations.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';

class MessagesPage extends StatelessMaterialPage<AppConfiguration> {
  const MessagesPage() : super(
    key:            const ValueKey('MessagesPage'),
    configuration:  const MessagesConfiguration(),
    child:          const MessagesScreen(),
  );
}
