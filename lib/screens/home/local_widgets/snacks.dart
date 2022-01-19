import 'dart:async';
import 'dart:collection';

import 'package:app_state/app_state.dart';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/router/snack_event.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class SnacksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = GetIt.instance.get<SnacksBloc>();
    return StreamBuilder<SnacksBlocState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(SnacksBlocState state) {
    final children = <Widget>[
      const SizedBox(height: 5),
    ];

    for (final event in state.events) {
      children.add(const SizedBox(height: 10));
      children.add(SnackWidget(event: event));
    }

    return Column(
      children: children,
    );
  }
}

class SnackWidget extends StatelessWidget {
  final SnackEvent event;

  static const _colors = {
    SnackEventType.error: AppStyle.errorColor,
  };

  SnackWidget({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _colors[event.type],
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(event.message),
      ),
    );
  }
}

class SnacksBloc extends Bloc {
  final _statesController = BehaviorSubject<SnacksBlocState>();
  Stream<SnacksBlocState> get states => _statesController.stream;
  final initialState = const SnacksBlocState(events: []);

  final _appState = GetIt.instance.get<AppState>();
  late final StreamSubscription _eventsSubscription;

  final _eventsMap = SplayTreeMap<int, SnackEvent>();
  int _nextId = 0;

  static const _duration = Duration(seconds: 5);

  SnacksBloc() {
    _eventsSubscription = _appState.events.listen(_onStateEvent);
  }

  void _onStateEvent(PageStackBlocEvent event) {
    if (event is PageStackPageBlocEvent) {
      final screenBlockEvent = event.pageBlocEvent;
      if (screenBlockEvent is SnackEvent) {
        _addSnack(screenBlockEvent);
      }
    }
  }

  void _addSnack(SnackEvent event) async {
    final id = _nextId++;
    _eventsMap[id] = event;
    _pushOutput();

    await Future.delayed(_duration);
    _eventsMap.remove(id);
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  SnacksBlocState _createState() {
    return SnacksBlocState(
      events: _eventsMap.values.toList(growable: false),
    );
  }

  @override
  void dispose() {
    _statesController.close();
    _eventsSubscription.cancel();
  }
}

class SnacksBlocState {
  final List<SnackEvent> events;

  const SnacksBlocState({
    required this.events,
  });
}
