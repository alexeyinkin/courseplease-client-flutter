import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/screens/filter/local_blocs/filter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FilterScreen<F extends AbstractFilter> extends StatefulWidget {
  final AbstractFilterScreenContentCubit<F> contentCubit;
  final Widget contentWidget;

  FilterScreen({
    required this.contentCubit,
    required this.contentWidget,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState<F>(contentCubit: contentCubit);

  static Future<FilterScreenResult?> show({
    required BuildContext context,
    required AbstractFilterScreenContentCubit contentCubit,
    required Widget contentWidget,
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context) => FilterScreen(
        contentCubit: contentCubit,
        contentWidget: contentWidget,
      ),
    );

    if (result == null) return null;
    if (!(result is FilterScreenResult)) throw Exception('Wrong type');
    return result;
  }
}

class _FilterScreenState<F extends AbstractFilter> extends State<FilterScreen> {
  final FilterScreenCubit<F> _cubit;

  _FilterScreenState({
    required AbstractFilterScreenContentCubit<F> contentCubit,
  }) :
      _cubit = FilterScreenCubit<F>(contentCubit: contentCubit)
  {
    _cubit.successes.listen((result) => _onSuccess(result));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FilterScreenCubitState>(
      stream: _cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(FilterScreenCubitState state) {
    return AlertDialog(
      content: Container(
        child: widget.contentWidget,
        width: 500,
      ),
      actions: [
        _getClearButton(state),
        _getApplyButton(state),
      ],
    );
  }

  Widget _getClearButton(FilterScreenCubitState state) {
    return ElevatedButton(
      onPressed: state.canClear ? _cubit.clear : null,
      child: Text(tr('FilterScreen.buttons.clear')),
    );
  }

  Widget _getApplyButton(FilterScreenCubitState state) {
    return ElevatedButton(
      onPressed: _cubit.apply,
      child: Text(tr('FilterScreen.buttons.apply')),
    );
  }

  void _onSuccess(FilterScreenResult<F> result) {
    Navigator.of(context).pop(result);
  }
}
