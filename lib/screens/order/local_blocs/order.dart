import 'dart:async';
import 'dart:convert';

import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/shop/line_item.dart';
import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class OrderScreenCubit extends Bloc {
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late final StreamSubscription _authenticationSubscription;

  final _statesController = BehaviorSubject<OrderScreenCubitState>();
  Stream<OrderScreenCubitState> get states => _statesController.stream;
  OrderScreenCubitState get currentState => _createState();

  final _navigationsController = BehaviorSubject<CreateCartAndOrderResponse>();
  Stream<CreateCartAndOrderResponse> get navigations => _navigationsController.stream;

  final _cancelsController = BehaviorSubject<void>();
  Stream<void> get cancels => _cancelsController.stream;

  final _errorsController = BehaviorSubject<void>();
  Stream<void> get errors => _errorsController.stream;

  final _successesController = BehaviorSubject<void>();
  Stream<void> get successes => _successesController.stream;

  AuthenticationState? _authenticationState;
  List<MoneyAccount> _accountsBefore = [];

  Money _topUpMoney;
  List<LineItem> _lineItems;
  OrderScreenCubitStatus _status = OrderScreenCubitStatus.waitingToProceed;

  OrderScreenCubit({
    Money? topUpMoney,
    List<LineItem>? lineItems,
  }) :
      _topUpMoney = topUpMoney ?? Money.zero(),
      _lineItems = lineItems ?? []
  {
    _authenticationSubscription = _authenticationCubit.outState.listen(
      _onAuthenticationStateChanged,
    );

    _processIfNotHolding();
  }

  void _onAuthenticationStateChanged(AuthenticationState state) {
    _authenticationState = state;
    _accountsBefore = state.data!.moneyAccounts;
    _pushOutput();
  }

  void _pushOutput() {
    if (_authenticationState == null) return; // Will push on change.

    final state = _createState();
    _statesController.sink.add(state);
  }

  OrderScreenCubitState _createState() {
    final subtotalMoney = _getSubtotalMoney();
    final holdMoney = _getHoldMoney(subtotalMoney);
    final payMoney = subtotalMoney.minus(holdMoney);
    final proceedAction = _getAction(holdMoney, payMoney);
    final accountsAfter = _getAccountsAfter(holdMoney);

    return OrderScreenCubitState(
      topUpMoney:       _topUpMoney,
      holdMoney:        holdMoney,
      accountsBefore:   _accountsBefore,
      accountsAfter:    accountsAfter,
      accountsSumAfter: MoneyAccount.getSum(accountsAfter),
      lineItems:        _lineItems,
      payMoney:         payMoney,
      proceedAction:    proceedAction,
      proceedMoney:     _getProceedMoney(action: proceedAction, holdMoney: holdMoney, payMoney: payMoney),
      canProceed:       _getCanProceed(holdMoney, payMoney),
      inProgress:       _status != OrderScreenCubitStatus.waitingToProceed,
      status:           _status,
    );
  }

  Money _getSubtotalMoney() {
    final result = Money.zero();

    result.addMoney(_topUpMoney);
    for (final listItem in _lineItems) {
      result.addMoney(
        (listItem.format.maxPrice ?? Money.zero()).times(listItem.quantity.toDouble())
      );
    }

    return result;
  }

  Money _getHoldMoney(Money subtotal) {
    if (subtotal.getCurCount() != 1) {
      throw Exception('Expected exactly 1 currency in subtotal, got ' + subtotal.toString());
    }
    final cur = subtotal.map.keys.first;
    final curBalance = MoneyAccount.getSumByCur(_accountsBefore, cur);

    return Money.min([subtotal, curBalance])!;
  }

  List<MoneyAccount> _getAccountsAfter(Money holdMoney) {
    if (holdMoney.isZero()) return _accountsBefore;

    final result = MoneyAccount.cloneList(_accountsBefore);

    for (final entry in holdMoney.splitByCurs().entries) {
      final leftToHold = entry.value;

      // First try bonus accounts if any.
      // If we introduce them, they would go after the real ones.
      for (final account in result.reversed) {
        if (account.cur != entry.key) continue;

        final canHoldOnAccount = Money.min([leftToHold, account.balance])!;
        if (canHoldOnAccount.isPositive()) {
          leftToHold.subtractMoney(canHoldOnAccount);
          account.balance.subtractMoney(canHoldOnAccount);
        }

        if (leftToHold.isZero()) break; // to next currency.
      }

      if (!leftToHold.isZero()) {
        throw Exception('Could not hold ' + leftToHold.toString());
      }
    }

    return result;
  }

  OrderAction _getAction(Money holdMoney, Money payMoney) {
    if (!holdMoney.isZero() && payMoney.isZero()) {
      return OrderAction.hold;
    }

    return OrderAction.pay;
  }

  Money _getProceedMoney({
    required OrderAction action,
    required Money holdMoney,
    required Money payMoney,
  }) {
    switch (action) {
      case OrderAction.pay: return payMoney;
      case OrderAction.hold: return holdMoney;
    }
    throw Exception('Unknown OrderAction: ' + action.toString());
  }

  bool _getCanProceed(Money holdMoney, Money payMoney) {
    if (_status != OrderScreenCubitStatus.waitingToProceed) return false;
    if (holdMoney.isZero() && payMoney.isZero()) return false;
    return true;
  }

  void _processIfNotHolding() {
    final state = _createState();

    if (state.holdMoney.isZero()) {
      process();
    }
  }

  void process() async {
    final request = CreateCartAndOrderRequest(lineItems: _lineItems);

    _status = OrderScreenCubitStatus.creatingOrder;
    _pushOutput();

    final response = await _apiClient.getOrCreateOrderAndPay(request);
    _onOrderCreated(response);
  }

  void _onOrderCreated(CreateCartAndOrderResponse response) {
    if (response.payRequest == null) {
      _onOrderComplete(); // Paid off the balance.
    } else {
      _navigationsController.sink.add(response);
    }
  }

  void _onOrderComplete() {
    _status = OrderScreenCubitStatus.complete;
    _pushOutput();

    _successesController.sink.add(true);
  }

  /// After redirecting from the payment gateway to our site,
  /// the page sends this message and closes the webview screen.
  void setWebViewResponse(String? json) {
    if (json == null) {
      _cancelsController.sink.add(true);
      return;
    }

    final map = jsonDecode(json);
    if (map['status'] != 1) {
      _errorsController.sink.add(true);
      return;
    }

    _onOrderComplete();
  }

  @override
  void dispose() {
    _authenticationSubscription.cancel();
    _navigationsController.close();
    _cancelsController.close();
    _errorsController.close();
    _successesController.close();
    _statesController.close();
  }
}

class OrderScreenCubitState {
  final Money topUpMoney;

  /// Amount on balance to be used towards the purchase.
  /// With [payMoney] it makes the total sum.
  final Money holdMoney;

  final List<MoneyAccount> accountsBefore;
  final List<MoneyAccount> accountsAfter;
  final Money accountsSumAfter;
  final List<LineItem> lineItems;

  /// Amount to be actually paid at the gateway.
  /// With [holdMoney] it makes the total sum.
  final Money payMoney;

  final OrderAction proceedAction;

  /// To be shown on a button, either [holdMoney] or [payMoney]
  /// depending on [proceedAction].
  final Money proceedMoney;

  final bool canProceed;
  final bool inProgress;
  final OrderScreenCubitStatus status;

  OrderScreenCubitState({
    required this.topUpMoney,
    required this.holdMoney,
    required this.accountsBefore,
    required this.accountsAfter,
    required this.accountsSumAfter,
    required this.lineItems,
    required this.payMoney,
    required this.proceedAction,
    required this.proceedMoney,
    required this.canProceed,
    required this.inProgress,
    required this.status,
  });
}

enum OrderScreenCubitStatus {
  waitingToProceed,
  creatingOrder,
  // TODO: Payment statuses here.
  complete,
}

enum OrderAction {
  /// Navigate to a gateway to pay real money.
  /// Additionally use balance money if can.
  pay,

  /// Use money from balance. It covers the order entirely.
  hold,
}
