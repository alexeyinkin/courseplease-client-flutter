import 'package:courseplease/models/filters/withdraw_account.dart';
import 'package:courseplease/models/shop/withdraw_account.dart';
import 'package:courseplease/repositories/withdraw_account.dart';
import 'package:courseplease/widgets/filtered_models_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WithdrawAccountDropdown extends StatelessWidget {
  final int? selectedId;
  final WithdrawAccountFilter filter;
  final ValueChanged<WithdrawAccount> onModelChanged;

  WithdrawAccountDropdown({
    required this.selectedId,
    required this.filter,
    required this.onModelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FilteredModelsDropdown<int, WithdrawAccount, WithdrawAccountFilter, WithdrawAccountRepository>(
      selectedId:     selectedId,
      filter:         filter,
      onModelChanged: onModelChanged,
      labelText:      tr('WithdrawAccountDropdown.label'),
    );
  }
}
