import 'dart:async';

import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/screens/schedule/local_blocs/schedule.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ScheduleScreen extends StatefulWidget {
  final Delivery  delivery;
  final int       chatId;
  final User?     anotherUser;

  ScheduleScreen({
    required this.delivery,
    required this.chatId,
    required this.anotherUser,
  });

  static void show({
    required BuildContext context,
    required Delivery delivery,
    required int chatId,
    required User? anotherUser,
  }) {
    showDialog(
      context: context,
      builder: (context) => ScheduleScreen(
        delivery:     delivery,
        chatId:       chatId,
        anotherUser:  anotherUser,
      ),
    );
  }

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState(
    delivery:     delivery,
    chatId:       chatId,
    anotherUser:  anotherUser,
  );
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleScreenCubit _scheduleScreenCubit;
  late final StreamSubscription _scheduleScreenCubitSubscription;

  _ScheduleScreenState({
    required Delivery delivery,
    required int chatId,
    required User? anotherUser,
  }) :
      _scheduleScreenCubit = ScheduleScreenCubit(
        delivery:     delivery,
        chatId:       chatId,
        anotherUser:  anotherUser,
      )
  {
    _scheduleScreenCubitSubscription = _scheduleScreenCubit.outState.listen(
      _onCubitStateChange,
    );
  }

  void _onCubitStateChange(ScheduleScreenCubitState state) {
    if (state.status == ScheduleScreenCubitStatus.complete) {
      _close();
    }
  }

  void _close() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScheduleScreenCubitState>(
      stream: _scheduleScreenCubit.outState,
      builder: (context, snapshot) => _buildWithStateOrNull(snapshot.data),
    );
  }

  Widget _buildWithStateOrNull(ScheduleScreenCubitState? state) {
    return (state == null)
        ? _buildLoading()
        : _buildWithState(state);
  }

  Widget _buildLoading() {
    return AlertDialog(
      content: SmallCircularProgressIndicator(),
    );
  }

  Widget _buildWithState(ScheduleScreenCubitState state) {
    return AlertDialog(
      title: Text(state.dialogTitle),
      content: _getContent(state),
      actions: [
        _getProceedButton(state),
      ],
    );
  }

  Widget _getContent(ScheduleScreenCubitState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SmallPadding(),
        _getDateRow(state),
        SmallPadding(),
        _getEarliestToStartRow(state),
        _getLatestToFinishRow(state),
        SmallPadding(),
        Text(
          tr(
            'ScheduleScreen.timeIsLocal',
            namedArgs: {'timezone': getTimeZoneString(state.earliestToStart)},
          ),
          style: AppStyle.minor,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getDateRow(ScheduleScreenCubitState state) {
    final handleDateTap = () => _handleDateTap(state);

    return Row(
      children: [
        GestureDetector(
          onTap: handleDateTap,
          child: Text(
            formatDetailedDate(state.earliestToStart, requireLocale(context)),
            style: AppStyle.h2,
          ),
        ),
        TextButton(
          child: Icon(
            Icons.edit,
            size: 30,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
          onPressed: handleDateTap,
        ),
      ],
    );
  }

  void _handleDateTap(ScheduleScreenCubitState state) async {
    final date = await showDatePicker(
      context: context,
      initialDate: state.earliestToStart,
      firstDate: state.earliestToStart,
      lastDate: state.earliestToStart.add(Duration(days: 60)),
    );

    if (date == null) return;

    _scheduleScreenCubit.setDate(date);
  }

  Widget _getEarliestToStartRow(ScheduleScreenCubitState state) {
    return Row(
      children: [
        Text(tr('ScheduleScreen.earliestToStart')),
        SizedBox(
          width: 30,
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.end,
            controller: state.earliestToStartHourController,
          ),
        ),
        Text(':'),
        SizedBox(
          width: 30,
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.end,
            controller: state.earliestToStartMinuteController,
          ),
        ),
      ],
    );
  }

  Widget _getLatestToFinishRow(ScheduleScreenCubitState state) {
    return Row(
      children: [
        Text(tr('ScheduleScreen.latestToFinish')),
        SizedBox(
          width: 30,
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.end,
            controller: state.latestToFinishHourController,
          ),
        ),
        Text(':'),
        SizedBox(
          width: 30,
          child: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.end,
            controller: state.earliestToStartMinuteController,
          ),
        ),
      ],
    );
  }

  Widget _getProceedButton(ScheduleScreenCubitState state) {
    return ElevatedButtonWithProgress(
      onPressed: _scheduleScreenCubit.proceed,
      enabled: state.canProceed,
      isLoading: state.inProgress,
      child: Text(state.buttonTitle),
    );
  }

  @override
  void dispose() {
    _scheduleScreenCubitSubscription.cancel();
    _scheduleScreenCubit.dispose();
    super.dispose();
  }
}
