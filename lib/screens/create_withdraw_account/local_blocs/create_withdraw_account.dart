import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/map_property_state.dart';
import 'package:courseplease/models/filters/withdraw_account.dart';
import 'package:courseplease/models/shop/withdraw_account.dart';
import 'package:courseplease/models/shop/withdraw_service.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/create_withdraw_account.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class CreateWithdrawAccountCubit extends Bloc {
  final WithdrawService service;

  final _apiClient = GetIt.instance.get<ApiClient>();
  final _titleController = TextEditingController();
  final _propertyControllers = <String, TextEditingController>{};

  final _statesController = BehaviorSubject<CreateWithdrawAccountCubitState>();
  Stream<CreateWithdrawAccountCubitState> get states => _statesController.stream;

  final _errorsController = BehaviorSubject<void>();
  Stream<void> get errors => _errorsController.stream;

  final _resultsController = BehaviorSubject<WithdrawAccount>();
  Stream<WithdrawAccount> get results => _resultsController.stream;

  late final CreateWithdrawAccountCubitState initialState;

  bool _inProgress = false;

  CreateWithdrawAccountCubit({
    required this.service,
  }) {
    for (final property in service.properties) {
      final controller = TextEditingController();
      controller.addListener(() => _onPropertyControllerChanged(controller));
      _propertyControllers[property.intName] = controller;
    }

    initialState = _createState();
  }

  void _onPropertyControllerChanged(TextEditingController controller) {
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  CreateWithdrawAccountCubitState _createState() {
    final propertyStates = <MapPropertyState>[];

    for (final property in service.properties) {
      propertyStates.add(
        MapPropertyState(
          property: property,
          textEditingController: _propertyControllers[property.intName]!,
        ),
      );
    }

    return CreateWithdrawAccountCubitState(
      titleController: _titleController,
      propertyStates: propertyStates,
      canSubmit: _getCanSubmit(),
      inProgress: _inProgress,
    );
  }

  bool _getCanSubmit() {
    if (_inProgress) return false;
    if (_titleController.text == '') return false;
    for (final controller in _propertyControllers.values) {
      if (controller.text == '') return false;
    }

    return true;
  }

  void proceed() async {
    final request = CreateWithdrawAccountRequest(
      title: _titleController.text,
      serviceId: service.id,
      properties: _getPropertyValues(),
    );

    _inProgress = true;
    _pushOutput();

    try {
      final account = await _apiClient.createWithdrawAccount(request);
      _addAccountToLists(account);
      _resultsController.sink.add(account);
    } catch (ex) {
      _errorsController.sink.add(true);
      _inProgress = false;
      _pushOutput();
    }
  }

  Map<String, String> _getPropertyValues() {
    final result = <String, String>{};

    for (final entry in _propertyControllers.entries) {
      result[entry.key] = entry.value.text;
    }

    return result;
  }

  void _addAccountToLists(WithdrawAccount account) {
    final cache = GetIt.instance.get<FilteredModelListCache>();
    final lists = cache.getModelListsByObjectAndFilterTypes<int, WithdrawAccount, WithdrawAccountFilter>();

    for (final list in lists.values) {
      if (list.filter.serviceId != service.id) {
        continue;
      }
      list.addAllToBeginning([account]);
    }
  }

  @override
  void dispose() {
    _statesController.close();
    _errorsController.close();
    _resultsController.close();

    _titleController.dispose();
    for (final controller in _propertyControllers.values) {
      controller.dispose();
    }
  }
}

class CreateWithdrawAccountCubitState {
  final TextEditingController titleController;
  final List<MapPropertyState> propertyStates;
  final bool canSubmit;
  final bool inProgress;

  CreateWithdrawAccountCubitState({
    required this.titleController,
    required this.propertyStates,
    required this.canSubmit,
    required this.inProgress,
  });
}
