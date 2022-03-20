import 'dart:async';

import 'package:app_state/app_state.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/select_product_subject/events.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import '../../blocs/authentication.dart';

class EditIntegrationBloc extends AppPageStatefulBloc<EditIntegrationState> {
  final EditableContact contactClone;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  late StreamSubscription _authenticationCubitSubscription;

  EditIntegrationCurrentAction _currentAction = EditIntegrationCurrentAction.none;
  late AuthenticationState _authenticationState;

  final _productSubjectChangesController = BehaviorSubject<ProductSubjectSelectedEvent>();
  Stream<ProductSubjectSelectedEvent> get productSubjectChanges => _productSubjectChangesController.stream;

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
  MyPageConfiguration? getConfiguration() => null;

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
  void onForegroundClosed(PageBlocCloseEvent event) {
    if (event is ProductSubjectSelectedEvent) {
      _productSubjectChangesController.add(event);
      return;
    }
  }

  @override
  void dispose() {
    _authenticationCubitSubscription.cancel();
    _productSubjectChangesController.close();
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
