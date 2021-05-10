import 'dart:math';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/models/shop/delivery.dart';
import 'package:courseplease/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ScheduleScreenCubit extends Bloc {
  final _outStateController = BehaviorSubject<ScheduleScreenCubitState>();
  Stream<ScheduleScreenCubitState> get outState => _outStateController.stream;

  final Delivery delivery;
  final User? anotherUser;

  late DateTime _earliestToStart;
  late DateTime _latestToFinish;
  final _earliestToStartHourController = TextEditingController();
  final _minuteController = TextEditingController();
  final _latestToFinishHourController = TextEditingController();

  ScheduleScreenCubit({
    required this.delivery,
    required this.anotherUser,
  }) {
    _earliestToStart = _getInitialEarliestToStart();
    _latestToFinish = _getInitialLatestToFinish(_earliestToStart);

    _earliestToStartHourController.text = _earliestToStart.hour.toString();
    _minuteController.text = _earliestToStart.minute.toString().padLeft(2, '0');
    _latestToFinishHourController.text = _latestToFinish.hour.toString();

    _earliestToStartHourController.addListener(_onEarliestToStartHourChange);
    _minuteController.addListener(_onMinuteChange);
    _latestToFinishHourController.addListener(_onLatestToFinishHourChange);

    _pushOutput();
  }

  DateTime _getInitialEarliestToStart() {
    final now = DateTime.now();

    if (now.hour >= 23) {
      return DateTime(
        now.year,
        now.month,
        now.day + 1,
        9,
      );
    }

    return DateTime(
      now.year,
      now.month,
      now.day,
      now.hour + 1,
    );
  }

  DateTime _getInitialLatestToFinish(DateTime earliestToStart) {
    final hour = min(earliestToStart.hour + 5, 24);
    return DateTime(
      earliestToStart.year,
      earliestToStart.month,
      earliestToStart.day,
      hour,
      earliestToStart.minute,
    );
  }

  void _onEarliestToStartHourChange() {
    final h = int.tryParse(_earliestToStartHourController.text) ?? 0;
    final fixedH = _fixHour(h);

    if (h != fixedH) {
      _earliestToStartHourController.text = fixedH.toString();
      return;
    }

    final earliestToStart = DateTime(
      _earliestToStart.year,
      _earliestToStart.month,
      _earliestToStart.day,
      fixedH,
      _earliestToStart.minute,
    );

    _setEarliestToStart(earliestToStart);
  }

  int _fixHour(int h) {
    if (h < 0) return 0;
    if (h > 23) return 23;
    return h;
  }

  void _onMinuteChange() {
    final m = int.tryParse(_minuteController.text) ?? 0;
    final fixedM = _fixMinute(m);

    if (m != fixedM) {
      _minuteController.text = fixedM.toString().padLeft(2, '0');
      return;
    }

    final earliestToStart = DateTime(
      _earliestToStart.year,
      _earliestToStart.month,
      _earliestToStart.day,
      _earliestToStart.hour,
      fixedM,
    );

    _setEarliestToStart(earliestToStart);
  }

  int _fixMinute(int m) {
    if (m < 0) return 0;
    if (m > 59) return 59;
    return m;
  }

  void _setEarliestToStart(DateTime dt) {
    _earliestToStart = _fixEarliestToStart(dt);
    _latestToFinish = _fixLatestToFinish(_earliestToStart, dt);
    _pushOutput();
  }

  DateTime _fixEarliestToStart(DateTime dt) {
    final now = DateTime.now();

    if (dt.isAfter(now)) return dt;

    final today = DateTime(
      now.year,
      now.month,
      now.day,
      dt.hour,
      dt.minute,
    );

    if (today.isAfter(now)) return today;
    return today.add(Duration(days: 1));
  }

  void _onLatestToFinishHourChange() {
    final h = int.tryParse(_latestToFinishHourController.text) ?? 0;
    final fixedH = _fixHour(h);

    if (h != fixedH) {
      _latestToFinishHourController.text = fixedH.toString();
      return;
    }

    final latestToFinish = DateTime(
      _latestToFinish.year,
      _latestToFinish.month,
      _latestToFinish.day,
      fixedH,
      _earliestToStart.minute,
    );

    _setLatestToFinish(latestToFinish);
  }

  void _setLatestToFinish(DateTime dt) {
    _latestToFinish = _fixLatestToFinish(_earliestToStart, dt);
    _pushOutput();
  }

  DateTime _fixLatestToFinish(DateTime earliestToStart, DateTime dt) {
    if (dt.isAfter(earliestToStart)) return dt;

    final sameDay = DateTime(
      earliestToStart.year,
      earliestToStart.month,
      earliestToStart.day,
      dt.hour,
      earliestToStart.minute,
    );

    if (sameDay.isAfter(earliestToStart)) return sameDay;
    return sameDay.add(Duration(days: 1));
  }

  void _pushOutput() {
    final state = _createState();
    _outStateController.sink.add(state);
  }

  ScheduleScreenCubitState _createState() {
    return ScheduleScreenCubitState(
      dialogTitle:                      _getDialogTitle(),
      buttonTitle:                      _getButtonTitle(),
      earliestToStart:                  _earliestToStart,
      latestToFinish:                   _latestToFinish,
      earliestToStartHourController:    _earliestToStartHourController,
      earliestToStartMinuteController:  _minuteController,
      latestToFinishHourController:     _latestToFinishHourController,
      canProceed:                       _canProceed(),
      inProgress:                       false,
    );
  }

  String _getDialogTitle() {
    return (anotherUser == null)
        ? _getDialogTitleWithoutName()
        : _getDialogTitleWithName();
  }

  String _getDialogTitleWithoutName() {
    final key = (delivery.dateTimeStart == null)
        ? 'ScheduleScreen.title.schedule'
        : 'ScheduleScreen.title.reschedule';
    return tr(key);
  }

  String _getDialogTitleWithName() {
    final key = (delivery.dateTimeStart == null)
        ? 'ScheduleScreen.titleWithName.schedule'
        : 'ScheduleScreen.titleWithName.reschedule';
    return tr(key, namedArgs: {'name': anotherUser!.firstName});
  }

  String _getButtonTitle() {
    final key = (delivery.dateTimeStart == null)
        ? 'ScheduleScreen.buttons.offer.schedule'
        : 'ScheduleScreen.buttons.offer.reschedule';
    return tr(key);
  }

  bool _canProceed() {
    return _earliestToStart.isAfter(DateTime.now());
  }

  void setDate(DateTime date) {
    final earliestToStart = DateTime(
      date.year,
      date.month,
      date.day,
      _earliestToStart.hour,
      _earliestToStart.minute,
    );

    final latestToFinish = DateTime(
      date.year,
      date.month,
      date.day,
      _latestToFinish.hour,
      _latestToFinish.minute,
    );

    _earliestToStart = earliestToStart;
    _latestToFinish = latestToFinish;
    _pushOutput();
  }

  void proceed() {
    // TODO
  }

  @override
  void dispose() {
    _latestToFinishHourController.dispose();
    _minuteController.dispose();
    _earliestToStartHourController.dispose();
    _outStateController.close();
  }
}

class ScheduleScreenCubitState {
  final String dialogTitle;
  final String buttonTitle;
  final DateTime earliestToStart;
  final DateTime latestToFinish;
  final TextEditingController earliestToStartHourController;
  final TextEditingController earliestToStartMinuteController;
  final TextEditingController latestToFinishHourController;
  final bool canProceed;
  final bool inProgress;

  ScheduleScreenCubitState({
    required this.dialogTitle,
    required this.buttonTitle,
    required this.earliestToStart,
    required this.latestToFinish,
    required this.earliestToStartHourController,
    required this.earliestToStartMinuteController,
    required this.latestToFinishHourController,
    required this.canProceed,
    required this.inProgress,
  });
}
