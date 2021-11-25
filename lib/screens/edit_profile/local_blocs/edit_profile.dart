import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/bloc.dart';
import 'package:courseplease/blocs/editors/location.dart';
import 'package:courseplease/models/language.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileScreenCubit extends Bloc {
  final _statesController = BehaviorSubject<EditProfileScreenCubitState>();
  Stream<EditProfileScreenCubitState> get states => _statesController.stream;

  final _resultsController = BehaviorSubject<DialogResult>();
  Stream<DialogResult> get results => _resultsController.stream;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _languageListController = LanguageListEditorController();
  final _locationController = LocationEditorController(geocode: true);
  String _sex;
  bool _inProgress = false;

  late final EditProfileScreenCubitState initialState;

  EditProfileScreenCubit({
    required User user,
  }) :
      _sex = user.sex
  {
    _firstNameController.text = user.firstName;
    _middleNameController.text = user.middleName;
    _lastNameController.text = user.lastName;
    _languageListController.setIds(user.langs);
    _locationController.value = user.location;

    initialState = _createState();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  EditProfileScreenCubitState _createState() {
    return EditProfileScreenCubitState(
      firstNameController: _firstNameController,
      middleNameController: _middleNameController,
      lastNameController: _lastNameController,
      languageListController: _languageListController,
      locationController: _locationController,
      sex: _sex,
      languages: _languageListController.nonNullValues,
      inProgress: _inProgress,
      canSave: _canSave(),
    );
  }

  bool _canSave() {
    return !_inProgress;
  }

  void setSex(String sex) {
    _sex = sex;
    _pushOutput();
  }

  void save() async {
    _inProgress = true;
    _pushOutput();

    final request = SaveProfileRequest(
      firstName:  _firstNameController.text,
      middleName: _middleNameController.text,
      lastName:   _lastNameController.text,
      sex:        _sex,
      langs:      _languageListController.getIds(),
      location:   _getSaveLocationRequest(),
    );

    try {
      await _authenticationCubit.saveProfile(request);
      _resultsController.sink.add(DialogResult(code: DialogResultCode.ok));
    } catch (ex) {
      _resultsController.sink.add(DialogResult(code: DialogResultCode.error));
      _inProgress = false;
      _pushOutput();
    }
  }

  SaveLocationRequest? _getSaveLocationRequest() {
    final location = _locationController.value;
    if (location == null) return null;

    return SaveLocationRequest(
      countryCode: location.countryCode,
      cityId: location.cityId,
      streetAddress: location.streetAddress,
      privacy: location.privacy,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _statesController.close();
    _resultsController.close();
  }
}

class EditProfileScreenCubitState {
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  final LanguageListEditorController languageListController;
  final LocationEditorController locationController;
  final String sex;
  final List<Language> languages;
  final bool inProgress;
  final bool canSave;

  EditProfileScreenCubitState({
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
    required this.languageListController,
    required this.locationController,
    required this.sex,
    required this.languages,
    required this.inProgress,
    required this.canSave,
  });
}
