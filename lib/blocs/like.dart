import 'dart:async';
import 'dart:collection';

import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/create_like.dart';
import 'package:courseplease/services/net/api_client/delete_like.dart';
import 'package:courseplease/services/net/api_client/like_action_response.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

/// This class keeps the local track of liked and de-liked items
/// while they have not yet refreshed from the server.
/// The state is kept for the duration of at least [_clearTimeout].
/// After this it is disposed. If during this time an item
/// was not refreshed from the server, consider either network problems
/// or that it was de-liked on another device. Let go of such likes anyway.
class LikeCubit extends Bloc {
  final _statesController = BehaviorSubject<LikeCubitState>();
  Stream<LikeCubitState> get states => _statesController.stream;

  late final LikeCubitState initialState;
  final _catalogStates = <String, LikeCubitCatalogState>{};
  Timer? _clearTimer;
  static const _clearTimeout = Duration(seconds: 15);
  final _apiClient = GetIt.instance.get<ApiClient>();

  LikeCubit() {
    initialState = _createState();
  }

  Future<LikeActionResponse> createLike(String catalog, int objectId) {
    _saveLikeAction(catalog, objectId, LikeAction.createLike);

    return _apiClient.createLike(
      CreateLikeRequest(catalog: catalog, objectId: objectId),
    );
  }

  Future<LikeActionResponse> deleteLike(String catalog, int objectId) {
    _saveLikeAction(catalog, objectId, LikeAction.deleteLike);

    return _apiClient.deleteLike(
      DeleteLikeRequest(catalog: catalog, objectId: objectId),
    );
  }

  void _saveLikeAction(String catalog, int objectId, LikeAction action) {
    if (!_catalogStates.containsKey(catalog)) {
      _catalogStates[catalog] = LikeCubitCatalogState();
    }

    if (!_catalogStates[catalog]!.objectLikeActions.containsKey(objectId)) {
      _catalogStates[catalog]!.objectLikeActions[objectId] = ObjectLikeActions();
    }

    _catalogStates[catalog]!.objectLikeActions[objectId]!.actions[DateTime.now().millisecondsSinceEpoch] = action;
    _setClearTimer();
    _pushOutput();
  }

  void _setClearTimer() {
    if (_clearTimer?.isActive ?? false) _clearTimer!.cancel();
    _clearTimer = Timer(_clearTimeout, () {
      _clear();
    });
  }

  void _clear() {
    _catalogStates.clear();
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  LikeCubitState _createState() {
    return LikeCubitState(
      catalogStates: _catalogStates,
    );
  }

  @override
  void dispose() {
    _statesController.close();
  }
}

class LikeCubitState {
  final Map<String, LikeCubitCatalogState> catalogStates;

  LikeCubitState({
    required this.catalogStates,
  });

  ObjectLikeActions getActionsFor(String catalog, int objectId) {
    if (!catalogStates.containsKey(catalog)) {
      return ObjectLikeActions.empty;
    }
    if (!catalogStates[catalog]!.objectLikeActions.containsKey(objectId)) {
      return ObjectLikeActions.empty;
    }
    return catalogStates[catalog]!.objectLikeActions[objectId]!;
  }
}

class LikeCubitCatalogState {
  final _objectLikeActions = <int, ObjectLikeActions>{};
  Map<int, ObjectLikeActions> get objectLikeActions => _objectLikeActions;
}

class ObjectLikeActions {
  static final empty = ObjectLikeActions();

  final _actions = SplayTreeMap<int, LikeAction>();
  SplayTreeMap<int, LikeAction> get actions => _actions;
}

enum LikeAction {
  createLike,
  deleteLike,
}
