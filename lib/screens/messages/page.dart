import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/messages/configurations.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';

class MessagesPage extends StatelessMaterialPage<MyPageConfiguration> {
  static const factoryKey = 'MessagesPage';

  const MessagesPage() : super(
    key:            const ValueKey(factoryKey),
    configuration:  const MessagesConfiguration(),
    child:          const MessagesScreen(),
  );
}
