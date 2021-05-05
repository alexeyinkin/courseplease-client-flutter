import 'dart:async';
import 'dart:math';

import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/shop/line_item.dart';
import 'package:courseplease/screens/home/local_blocs/home.dart';
import 'package:courseplease/screens/order/local_blocs/order.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/shop/line_item.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class OrderScreen extends StatefulWidget {
  final Money? initialTopUpMoney;
  final List<LineItem>? initialLineItems;

  OrderScreen({
    this.initialTopUpMoney,
    this.initialLineItems,
  });

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
  final _homeScreenCubit = GetIt.instance.get<HomeScreenCubit>();
  late final StreamSubscription _orderScreenCubitSubscription;

  _OrderScreenState({
    Money? initialTopUpMoney,
    List<LineItem>? initialLineItems,
  }) :
      _orderScreenCubit = OrderScreenCubit(
        topUpMoney: initialTopUpMoney,
        lineItems: initialLineItems,
      )
  {
    _orderScreenCubitSubscription = _orderScreenCubit.outState.listen(
      _onStateChange
    );
  }

  void _onStateChange(OrderScreenCubitState state) {
    _homeScreenCubit.setCurrentTab(HomeScreenTab.messages);

    if (state.status == OrderScreenCubitStatus.complete) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderScreenCubitState>(
      stream: _orderScreenCubit.outState,
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
          ..._getLineItems(state.lineItems),
          _getBalanceRowIfUsed(state),
          _getPayableRowIfNeed(state),
          _getTerms(state),
        ],
      ),
    );
  }

  List<Widget> _getLineItems(List<LineItem> lineItems) {
    final result = <Widget>[];

    for (final lineItem in lineItems) {
      result.add(
        LineItemWidget(lineItem: lineItem),
      );
    }

    return result;
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
      onPressed: _orderScreenCubit.process,
      enabled: state.canProceed,
      isLoading: state.inProgress,
      child: Text(
        tr(
          'OrderScreen.action.' + enumValueAfterDot(state.proceedAction.toString()),
          namedArgs: {'amount': state.proceedMoney.toString()},
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderScreenCubitSubscription.cancel();
    _orderScreenCubit.dispose();
    super.dispose();
  }
}
