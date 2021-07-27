import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/filters/money_account_transaction.dart';
import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/auth/sign_in.dart';
import 'package:courseplease/widgets/fitted_icon_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'local_widgets/money_account_transaction_table.dart';

class MoneyAccountTransactionsScreen extends StatefulWidget {
  // TODO: Use, now showing first tab.
  final String initialCur;

  MoneyAccountTransactionsScreen({
    required this.initialCur,
  });

  static void show({
    required BuildContext context,
    required String cur,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MoneyAccountTransactionsScreen(
          initialCur: cur,
        ),
      ),
    );
  }

  @override
  _MoneyAccountTransactionsScreenState createState() => _MoneyAccountTransactionsScreenState();
}

class _MoneyAccountTransactionsScreenState extends State<MoneyAccountTransactionsScreen> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<AuthenticationState>(
          stream: _authenticationCubit.outState,
          builder: (context, snapshot) => _buildWithState(snapshot.data ?? _authenticationCubit.initialState),
        ),
      ),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    final meResponseData = state.data;
    if (meResponseData?.user == null) return SignInWidget();

    return state.data!.moneyAccounts.isEmpty
        ? _buildPlaceholder()
        : _buildWithAccounts(meResponseData!);
  }

  Widget _buildPlaceholder() {
    return FittedIconTextWidget(
      iconData: Icons.monetization_on,
      text: tr('MoneyAccountTransactionsScreen.placeholder'),
    );
  }

  Widget _buildWithAccounts(MeResponseData meResponseData) {
    return DefaultTabController(
      length: meResponseData.moneyAccounts.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTabBar(meResponseData.moneyAccounts),
          Expanded(
            child: _getTabsContents(meResponseData.moneyAccounts),
          ),
        ],
      ),
    );
  }

  Widget _getTabBar(List<MoneyAccount> accounts) {
    final tabs = <Widget>[];

    for (final account in accounts) {
      tabs.add(
        Tab(
          text: account.cur,
        ),
      );
    }

    return TabBar(tabs: tabs);
  }

  Widget _getTabsContents(List<MoneyAccount> accounts) {
    final tabs = <Widget>[];

    for (final account in accounts) {
      final filter = MoneyAccountTransactionFilter(
        cur: account.cur,
      );

      tabs.add(
        MoneyAccountTransactionTable(
          filter: filter,
        ),
      );
    }

    return TabBarView(
      children: tabs,
    );
  }
}
