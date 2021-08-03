import 'package:courseplease/models/filters/withdraw_service.dart';
import 'package:courseplease/models/shop/withdraw_service.dart';
import 'package:courseplease/repositories/withdraw_service.dart';
import 'package:courseplease/widgets/filtered_models_dropdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WithdrawServiceDropdown extends StatelessWidget {
  final int? selectedId;
  final WithdrawServiceFilter filter;
  final ValueChanged<WithdrawService> onModelChanged;

  WithdrawServiceDropdown({
    required this.selectedId,
    required this.filter,
    required this.onModelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FilteredModelsDropdown<int, WithdrawService, WithdrawServiceFilter, WithdrawServiceRepository>(
      selectedId:     selectedId,
      filter:         filter,
      onModelChanged: onModelChanged,
      // TODO: Hide label when hint is shown, then uncomment.
      //labelText:      tr('WithdrawServiceDropdown.label'),
      hint:           Text(tr('WithdrawServiceDropdown.hint')),
    );
  }
}
