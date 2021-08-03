import 'package:courseplease/models/filters/withdraw_account.dart';
import 'package:courseplease/models/filters/withdraw_service.dart';
import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/models/shop/withdraw_order.dart';
import 'package:courseplease/screens/create_withdraw_account/create_withdraw_account.dart';
import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:courseplease/screens/withdraw/local_blocs/withdraw.dart';
import 'package:courseplease/screens/withdraw/local_widgets/withdraw_account_dropdown.dart';
import 'package:courseplease/screens/withdraw/local_widgets/withdraw_account_properties.dart';
import 'package:courseplease/screens/withdraw/local_widgets/withdraw_service_dropdown.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/edit_money.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WithdrawScreen extends StatefulWidget {
  final MoneyAccount account;

  WithdrawScreen({
    required this.account,
  }) : super(
    key: ValueKey('account_' + account.cur),
  );

  static Future<WithdrawOrder?> show({
    required BuildContext context,
    required MoneyAccount account,
  }) {
    return showDialog(
      context: context,
      builder: (context) => WithdrawScreen(
        account: account,
      ),
    );
  }

  @override
  _WithdrawScreenState createState() => _WithdrawScreenState(
    account: account,
  );
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  final WithdrawScreenCubit _cubit;

  _WithdrawScreenState({
    required MoneyAccount account,
  }) :
      _cubit = WithdrawScreenCubit(account: account)
  {
    _cubit.errors.listen((_) => _onError());
    _cubit.results.listen(_onSuccess);
  }

  void _onError() {
    ErrorPopupScreen.show(context);
  }

  void _onSuccess(WithdrawOrder order) {
    Navigator.of(context).pop(order);
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WithdrawScreenCubitState>(
      stream: _cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(WithdrawScreenCubitState state) {
    final filter = WithdrawServiceFilter(fromCur: widget.account.cur);

    return AlertDialog(
      title: Text(tr('WithdrawScreen.title')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WithdrawServiceDropdown(
            selectedId: state.withdrawService?.id,
            filter: filter,
            onModelChanged: _cubit.setWithdrawService,
          ),
          _getWithdrawAccountRowIfNeed(state),
          SmallPadding(),
          _getMoneyRow(state),
        ],
      ),
      actions: [
        _getProceedButton(state),
      ],
    );
  }

  Widget _getWithdrawAccountRowIfNeed(WithdrawScreenCubitState state) {
    final serviceId = state.withdrawService?.id;
    if (serviceId == null) return Container();

    final filter = WithdrawAccountFilter(serviceId: serviceId);

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: WithdrawAccountDropdown(
                  selectedId: state.withdrawAccount?.id,
                  filter: filter,
                  onModelChanged: _cubit.setWithdrawAccount,
                ),
              ),
              SmallPadding(),
              ElevatedButton(
                child: Text(tr('WithdrawScreen.buttons.addAccount')),
                onPressed: () => _onAddAccountPressed(state),
              ),
            ],
          ),
          _getAccountPropertiesIfNeed(state),
        ],
      ),
    );
  }

  Widget _getAccountPropertiesIfNeed(WithdrawScreenCubitState state) {
    final account = state.withdrawAccount;
    if (account == null) return Container();

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: WithdrawAccountPropertiesWidget(
        service: state.withdrawService!,
        account: account,
      ),
    );
  }

  Widget _getMoneyRow(WithdrawScreenCubitState state) {
    return Container(
      alignment: Alignment.centerRight,
      child: EditMoneyWidget(
        money: state.money,
        curs: [widget.account.cur],
        valueController: state.valueController,
      ),
    );
  }

  Widget _getProceedButton(WithdrawScreenCubitState state) {
    return ElevatedButtonWithProgress(
      child: Text(tr('WithdrawScreen.buttons.withdraw')),
      isLoading: state.inProgress,
      onPressed: _cubit.proceed,
      enabled: state.canProceed,
    );
  }

  void _onAddAccountPressed(WithdrawScreenCubitState state) async {
    final account = await CreateWithdrawAccountScreen.show(
      context: context,
      service: state.withdrawService!,
    );

    if (account == null) return;

    _cubit.setWithdrawAccount(account);
  }
}
