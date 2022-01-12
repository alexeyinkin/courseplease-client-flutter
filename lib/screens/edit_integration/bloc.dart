import 'dart:async';
import 'package:courseplease/blocs/screen.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/router/screen_configuration.dart';
import 'package:courseplease/screens/edit_integration/configurations.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import '../../blocs/authentication.dart';

class EditIntegrationBloc extends AppScreenBloc<EditIntegrationState> {
  final EditableContact contactClone;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late StreamSubscription _authenticationCubitSubscription;

  EditIntegrationCurrentAction _currentAction = EditIntegrationCurrentAction.none;
  late AuthenticationState _authenticationState;

  EditIntegrationBloc({
    required this.contactClone,
  }) {
    _authenticationState = _authenticationCubit.initialState;
    _authenticationCubitSubscription = _authenticationCubit.outState.listen(_onAuthenticationChange);
  }

  void _onAuthenticationChange(AuthenticationState state) {
    _authenticationState = state;
    emitState();
  }

  @override
  EditIntegrationState createState() {
    final contact = _getContact();

    if (contact == null) {
      throw Exception('Contact not found');
    }

    return EditIntegrationState(
      contact: contact,
      meResponseData: _authenticationState.data!,
      currentAction: _currentAction,
    );
  }

  EditableContact? _getContact() {
    for (final contact in _authenticationState.data?.contacts ?? []) {
      if (contact.id == contactClone.id) return contact;
    }
    return null;
  }

  @override
  ScreenConfiguration get currentConfiguration {
    return EditIntegrationConfiguration(contactId: contactClone.id);
  }

  void synchronize() async {
    _currentAction = EditIntegrationCurrentAction.sync;
    emitState();
    await _authenticationCubit.synchronizeProfileSynchronously(contactClone.id);

    if (_currentAction == EditIntegrationCurrentAction.sync) {
      _currentAction = EditIntegrationCurrentAction.none;
      emitState();
    }
  }

  void setDownloadEnabled(bool value) {
    contactClone.downloadEnabled = value;
    emitState();
  }

  Future<void> saveContactParams(SaveContactParamsRequest request) async {
    _currentAction = EditIntegrationCurrentAction.save;
    emitState();

    try {
      await _authenticationCubit.saveContactParams(request);
      emitSaved();
      closeScreen();
    } catch (e) {
      _currentAction = EditIntegrationCurrentAction.none;
      emitState();
      emitUnknownError();
    }
  }

  @override
  void dispose() {
    _authenticationCubitSubscription.cancel();
    super.dispose();
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
