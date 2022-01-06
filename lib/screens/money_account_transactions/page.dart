import 'package:app_state/app_state.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';

class MoneyAccountTransactionsPage extends StatelessMaterialPage<AppConfiguration> {
  MoneyAccountTransactionsPage() : super(
    key: ValueKey('MoneyAccountTransactionsPage'),
    child: MoneyAccountTransactionsScreen(),
  );
}
