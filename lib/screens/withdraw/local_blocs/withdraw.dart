import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/filters/withdraw_order.dart';
import 'package:courseplease/models/money.dart';
import 'package:courseplease/models/shop/enum/withdraw_order_status.dart';
import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/models/shop/withdraw_account.dart';
import 'package:courseplease/models/shop/withdraw_order.dart';
import 'package:courseplease/models/shop/withdraw_service.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/create_withdraw_order.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class WithdrawScreenCubit extends Bloc {
  final MoneyAccount account;

  final _apiClient = GetIt.instance.get<ApiClient>();
  final _statesController = BehaviorSubject<WithdrawScreenCubitState>();
  Stream<WithdrawScreenCubitState> get states => _statesController.stream;

  final _errorsController = BehaviorSubject<void>();
  Stream<void> get errors => _errorsController.stream;

  final _resultsController = BehaviorSubject<WithdrawOrder>();
  Stream<WithdrawOrder> get results => _resultsController.stream;

  late final WithdrawScreenCubitState initialState;

  final _money; // This very object is changed by EditMoneyWidget.
  final _valueController = TextEditingController();
  WithdrawService? _withdrawService;
  WithdrawAccount? _withdrawAccount;
  bool _inProgress = false;

  WithdrawScreenCubit({
    required this.account,
  }) :
      _money = Money.from(account.balance)
  {
    initialState = _createState();
  }

  void setWithdrawService(WithdrawService service) {
    if (service.id == _withdrawService?.id) return;
    _withdrawService = service;
    _withdrawAccount = null;
    _pushOutput();
  }

  void setWithdrawAccount(WithdrawAccount withdrawAccount) {
    if (withdrawAccount.id == _withdrawAccount?.id) return;
    _withdrawAccount = withdrawAccount;
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  WithdrawScreenCubitState _createState() {
    return WithdrawScreenCubitState(
      withdrawService:  _withdrawService,
      withdrawAccount:  _withdrawAccount,
      money:            _money,
      valueController:  _valueController,
      canProceed:       _getCanProceed(),
      inProgress:       _inProgress,
    );
  }

  bool _getCanProceed() {
    if (_withdrawService == null) return false;
    if (_withdrawAccount == null) return false;
    if (_inProgress) return false;

    final value = double.tryParse(_valueController.text);
    if (value == null) return false;
    if (value < 0 || value > account.balance.getFirstValue()!) return false;

    return true;
  }

  void proceed() async {
    final request = CreateWithdrawOrderRequest(
      withdrawAccountId: _withdrawAccount!.id,
      value: double.parse(_valueController.text),
      cur: account.cur,
    );

    _inProgress = true;
    _pushOutput();

    try {
      final order = await _apiClient.createWithdrawOrder(request);
      _addOrderToLists(order);
      _resultsController.sink.add(order);
    } catch (ex) {
      _errorsController.sink.add(true);
      _inProgress = false;
      _pushOutput();
    }
  }

  void _addOrderToLists(WithdrawOrder order) {
    final cache = GetIt.instance.get<FilteredModelListCache>();
    final lists = cache.getModelListsByObjectAndFilterTypes<int, WithdrawOrder, WithdrawOrderFilter>();

    for (final list in lists.values) {
      if (list.filter.status != WithdrawOrderStatusEnum.created) {
        continue;
      }
      list.addAllToBeginning([order]);
    }
  }

  @override
  void dispose() {
    _statesController.close();
    _errorsController.close();
    _resultsController.close();
    _valueController.dispose();
  }
}

class WithdrawScreenCubitState {
  final WithdrawService? withdrawService;
  final WithdrawAccount? withdrawAccount;
  final Money money;
  final TextEditingController valueController;
  final bool canProceed;
  final bool inProgress;

  WithdrawScreenCubitState({
    required this.withdrawService,
    required this.withdrawAccount,
    required this.money,
    required this.valueController,
    required this.canProceed,
    required this.inProgress,
  });
}
