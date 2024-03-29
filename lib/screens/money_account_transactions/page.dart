import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:flutter/foundation.dart';

import 'screen.dart';

class MoneyAccountTransactionsPage extends StatelessMaterialPage<MyPageConfiguration> {
  MoneyAccountTransactionsPage() : super(
    key: ValueKey('MoneyAccountTransactionsPage'),
    child: MoneyAccountTransactionsScreen(),
  );
}
