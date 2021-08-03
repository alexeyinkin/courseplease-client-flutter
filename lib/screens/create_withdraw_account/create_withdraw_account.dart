import 'package:courseplease/blocs/map_property_state.dart';
import 'package:courseplease/models/shop/withdraw_account.dart';
import 'package:courseplease/models/shop/withdraw_service.dart';
import 'package:courseplease/screens/create_withdraw_account/local_blocs/create_withdraw_account.dart';
import 'package:courseplease/screens/error_popup/error_popup.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Pops [true] if created.
class CreateWithdrawAccountScreen extends StatefulWidget {
  final WithdrawService service;

  CreateWithdrawAccountScreen({
    required this.service,
  }) : super(
    key: ValueKey(service.id),
  );

  static Future<WithdrawAccount?> show({
    required BuildContext context,
    required WithdrawService service,
  }) {
    return showDialog<WithdrawAccount>(
      context: context,
      builder: (context) => CreateWithdrawAccountScreen(
        service: service,
      ),
    );
  }

  @override
  _CreateWithdrawAccountScreenState createState() => _CreateWithdrawAccountScreenState(
    service: service,
  );
}

class _CreateWithdrawAccountScreenState extends State<CreateWithdrawAccountScreen> {
  final CreateWithdrawAccountCubit _cubit;

  _CreateWithdrawAccountScreenState({
    required WithdrawService service,
  }) :
      _cubit = CreateWithdrawAccountCubit(
        service: service,
      )
  {
    _cubit.errors.listen((_) => _onError());
    _cubit.results.listen(_onSuccess);
  }

  void _onError() {
    ErrorPopupScreen.show(context);
  }

  void _onSuccess(WithdrawAccount account) {
    Navigator.of(context).pop(account);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CreateWithdrawAccountCubitState>(
      stream: _cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(CreateWithdrawAccountCubitState state) {
    return AlertDialog(
      title: Text(tr('CreateWithdrawAccountScreen.title')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: state.titleController,
            labelText: tr('CreateWithdrawAccountScreen.inputs.title'),
          ),
          SmallPadding(),
          ..._getPropertyFields(state),
        ]
      ),
      actions: [
        _getAddButton(state),
      ],
    );
  }

  List<Widget> _getPropertyFields(CreateWithdrawAccountCubitState state) {
    final result = <Widget>[];

    for (final propertyState in state.propertyStates) {
      result.add(_getPropertyField(propertyState));
    }

    return alternateWidgetListWith(result, SmallPadding());
  }

  Widget _getPropertyField(MapPropertyState propertyState) {
    return AppTextField(
      controller: propertyState.textEditingController,
      labelText: propertyState.property.title,
    );
  }

  Widget _getAddButton(CreateWithdrawAccountCubitState state) {
    return ElevatedButtonWithProgress(
      child: Text(tr('CreateWithdrawAccountScreen.buttons.add')),
      isLoading: state.inProgress,
      onPressed: _cubit.proceed,
      enabled: state.canSubmit,
    );
  }
}
