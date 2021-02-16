import 'dart:async';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../../../blocs/authentication.dart';
import '../../../blocs/bloc.dart';

class EditIntegrationCubit extends Bloc {
  final int _contactId;

  final _outStateController = BehaviorSubject<EditIntegrationState>();
  Stream<EditIntegrationState> get outState => _outStateController.stream;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  StreamSubscription _authenticationCubitSubscription;

  EditIntegrationCurrentAction _currentAction = EditIntegrationCurrentAction.none;
  AuthenticationState _authenticationState;

  EditIntegrationCubit({
    @required int contactId,
  }) :
        _contactId = contactId
  {
    _authenticationCubitSubscription = _authenticationCubit.outState.listen(_onAuthenticationChange);
  }

  void _onAuthenticationChange(AuthenticationState state) {
    _authenticationState = state;
    _pushOutput();
  }

  void _pushOutput() {
    _outStateController.sink.add(
      EditIntegrationState(
        contact: _getContact(),
        meResponseData: _authenticationState.data,
        currentAction: _currentAction,
      ),
    );
  }

  EditableContact _getContact() { // Return Nullable.
    for (final contact in _authenticationState.data.contacts) {
      if (contact.id == _contactId) return contact;
    }
    return null;
  }

  void synchronize() async {
    _currentAction = EditIntegrationCurrentAction.sync;
    _pushOutput();
    await _authenticationCubit.syncProfileSync(_contactId);

    if (_currentAction == EditIntegrationCurrentAction.sync) {
      _currentAction = EditIntegrationCurrentAction.none;
      _pushOutput();
    }
  }

  Future saveContactParams(SaveContactParamsRequest request) async {
    _currentAction = EditIntegrationCurrentAction.save;
    _pushOutput();
    await _authenticationCubit.saveContactParams(request);

    if (_currentAction == EditIntegrationCurrentAction.save) {
      _currentAction = EditIntegrationCurrentAction.none;
      _pushOutput();
    }
  }

  @override
  void dispose() {
    _authenticationCubitSubscription.cancel();
    _outStateController.close();
  }
}

class EditIntegrationState {
  final EditableContact contact; // Nullable
  final MeResponseData meResponseData;
  final EditIntegrationCurrentAction currentAction;

  EditIntegrationState({
    @required this.contact,
    @required this.meResponseData,
    @required this.currentAction,
  });
}

enum EditIntegrationCurrentAction {
  none,
  sync,
  save,
}
