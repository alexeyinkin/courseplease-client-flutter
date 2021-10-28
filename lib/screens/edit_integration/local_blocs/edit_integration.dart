import 'dart:async';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import '../../../blocs/authentication.dart';
import '../../../blocs/bloc.dart';

class EditIntegrationCubit extends Bloc {
  final int _contactId;

  final _outStateController = BehaviorSubject<EditIntegrationState>();
  Stream<EditIntegrationState> get outState => _outStateController.stream;

  final _errorsController = BehaviorSubject<void>();
  Stream<void> get errors => _errorsController.stream;

  final _successesController = BehaviorSubject<void>();
  Stream<void> get successes => _successesController.stream;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late StreamSubscription _authenticationCubitSubscription;

  EditIntegrationCurrentAction _currentAction = EditIntegrationCurrentAction.none;
  late AuthenticationState _authenticationState;

  EditIntegrationCubit({
    required int contactId,
  }) :
      _contactId = contactId
  {
    _authenticationState = _authenticationCubit.initialState;
    _authenticationCubitSubscription = _authenticationCubit.outState.listen(_onAuthenticationChange);
  }

  void _onAuthenticationChange(AuthenticationState state) {
    _authenticationState = state;
    _pushOutput();
  }

  void _pushOutput() {
    final contact = _getContact();

    if (contact == null) {
      _outStateController.sink.addError('Contact not found: ' + _contactId.toString());
      return;
    }

    _outStateController.sink.add(
      EditIntegrationState(
        contact: contact,
        meResponseData: _authenticationState.data!,
        currentAction: _currentAction,
      ),
    );
  }

  EditableContact? _getContact() {
    for (final contact in _authenticationState.data?.contacts ?? []) {
      if (contact.id == _contactId) return contact;
    }
    return null;
  }

  void synchronize() async {
    _currentAction = EditIntegrationCurrentAction.sync;
    _pushOutput();
    await _authenticationCubit.synchronizeProfileSynchronously(_contactId);

    if (_currentAction == EditIntegrationCurrentAction.sync) {
      _currentAction = EditIntegrationCurrentAction.none;
      _pushOutput();
    }
  }

  Future<void> saveContactParams(SaveContactParamsRequest request) async {
    _currentAction = EditIntegrationCurrentAction.save;
    _pushOutput();

    try {
      await _authenticationCubit.saveContactParams(request);
      _successesController.sink.add(null);
    } catch (e) {
      _errorsController.sink.add(null);
    }

    if (_currentAction == EditIntegrationCurrentAction.save) {
      _currentAction = EditIntegrationCurrentAction.none;
      _pushOutput();
    }
  }

  @override
  void dispose() {
    _authenticationCubitSubscription.cancel();
    _outStateController.close();
    _errorsController.close();
    _successesController.close();
  }
}

class EditIntegrationState {
  final EditableContact contact;
  final MeResponseData meResponseData;
  final EditIntegrationCurrentAction currentAction;

  EditIntegrationState({
    required this.contact,
    required this.meResponseData,
    required this.currentAction,
  });
}

enum EditIntegrationCurrentAction {
  none,
  sync,
  save,
}
