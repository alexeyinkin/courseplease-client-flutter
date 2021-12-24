import 'dart:math';

import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/shop/line_item.dart';
import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:courseplease/screens/order/local_blocs/order.dart';
import 'package:courseplease/screens/webview/webview.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/app_navigator.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/shop/line_items.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final Money? initialTopUpMoney;
  final List<LineItem>? initialLineItems;

  OrderScreen({
    this.initialTopUpMoney,
    this.initialLineItems,
  });

  // TODO: Fix not closing on back button.
  static void show({
    required BuildContext context,
    Money? topUpMoney,
    List<LineItem>? lineItems,
  }) {
    showDialog(
      context: context,
      builder: (context) => OrderScreen(
        initialTopUpMoney: topUpMoney,
        initialLineItems: lineItems,
      ),
    );
  }

  @override
  _OrderScreenState createState() => _OrderScreenState(
    initialTopUpMoney: initialTopUpMoney,
    initialLineItems: initialLineItems,
  );
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderScreenCubit _orderScreenCubit;

  _OrderScreenState({
    Money? initialTopUpMoney,
    List<LineItem>? initialLineItems,
  }) :
      _orderScreenCubit = OrderScreenCubit(
        topUpMoney: initialTopUpMoney,
        lineItems: initialLineItems,
      )
  {
    _orderScreenCubit.navigations.listen(_navigateToGateway);
    _orderScreenCubit.cancels.listen((_) => _close());
    _orderScreenCubit.errors.listen((_) => _onError());
    _orderScreenCubit.successes.listen((_) => _onSuccess());
  }

  void _navigateToGateway(CreateCartAndOrderResponse response) async {
    final messageJson = await WebViewScreen.show(
      url: response.payRequest!.url,
      title: LineItemsWidget(
        lineItems: _orderScreenCubit.currentState.lineItems,
        showPrice: false,
      ),
      toolbarHeight: 80, // TODO: Adjust if multiple items or add '+ 1 more'.
    );

    _orderScreenCubit.setWebViewResponse(messageJson);
  }

  void _onError() {
    ErrorPopupScreen.show(context: context);
  }

  void _onSuccess() {
    AppNavigator(context).toLastPurchasedLesson();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderScreenCubitState>(
      stream: _orderScreenCubit.states,
      builder: (context, snapshot) => _buildWithStateOrNull(snapshot.data),
    );
  }

  Widget _buildWithStateOrNull(OrderScreenCubitState? state) {
    return (state == null)
        ? _buildLoading()
        : _buildWithState(state);
  }

  Widget _buildLoading() {
    return AlertDialog(
      content: SmallCircularProgressIndicator(),
    );
  }

  Widget _buildWithState(OrderScreenCubitState state) {
    return AlertDialog(
      title: Text(tr('OrderScreen.title')),
      content: _getContent(state),
      actions: [
        _getProceedButton(state),
      ],
    );
  }

  Widget _getContent(OrderScreenCubitState state) {
    final screenSize = MediaQuery.of(context).size;
    final width = min(screenSize.width - 100, 400);
    return Container(
      width: width.toDouble(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LineItemsWidget(lineItems: state.lineItems, showPrice: true),
          _getBalanceRowIfUsed(state),
          _getPayableRowIfNeed(state),
          _getTerms(state),
        ],
      ),
    );
  }

  Widget _getBalanceRowIfUsed(OrderScreenCubitState state) {
    if (state.holdMoney.isZero()) return Container(width: 0, height: 0);

    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(tr('OrderScreen.useBalance'))),
          Text(state.holdMoney.toString()),
        ],
      ),
      subtitle: Text(
        tr(
          'OrderScreen.balanceAfter',
          namedArgs: {'amount': state.accountsSumAfter.toString()},
        ),
      ),
    );
  }

  Widget _getPayableRowIfNeed(OrderScreenCubitState state) {
    if (state.holdMoney.isZero()) return Container(width: 0, height: 0);

    return Column(
      children: [
        HorizontalLine(),
        ListTile(
          title: Row(
            children: [
              Expanded(child: Text(tr('OrderScreen.payable'))),
              Text(state.payMoney.toString()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getTerms(OrderScreenCubitState state) {
    return Container(
      child: Opacity(
        opacity: .5,
        child: Text(
          tr('OrderScreen.lessonTerms'),
          style: TextStyle(fontSize: 12),
          //style: AppStyle.minor,
        ),
      ),
    );
  }

  Widget _getProceedButton(OrderScreenCubitState state) {
    return ElevatedButtonWithProgress(
      onPressed: _orderScreenCubit.proceed,
      enabled: state.canProceed,
      isLoading: state.inProgress,
      child: Text(
        tr(
          'OrderScreen.action.' + state.proceedAction.name,
          namedArgs: {'amount': state.proceedMoney.toString()},
        ),
      ),
    );
  }

  void _close() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _orderScreenCubit.dispose();
    super.dispose();
  }
}
