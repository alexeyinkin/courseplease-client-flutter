import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/editors/location.dart';
import 'package:courseplease/blocs/screen.dart';
import 'package:courseplease/models/enum/sex.dart';
import 'package:courseplease/router/app_configuration.dart';
import 'package:courseplease/screens/edit_profile/configurations.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class EditProfileBloc extends AppScreenBloc<EditProfileScreenCubitState> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final languageListController = LanguageListEditorController();
  final locationController = LocationEditorController(geocode: true);
  String _sex;
  bool _inProgress = false;

  get initialState => const EditProfileScreenCubitState(
    sex: SexEnum.unknown,
    inProgress: false,
    canSave: true,
  );

  EditProfileBloc() :
      // TODO: SexController
      _sex = GetIt.instance.get<AuthenticationBloc>().currentState.data?.user?.sex ?? SexEnum.unknown
  {
    final user = GetIt.instance.get<AuthenticationBloc>().currentState.data?.user;
    if (user == null) throw Exception('Unauthenticated.');

    firstNameController.text = user.firstName;
    middleNameController.text = user.middleName;
    lastNameController.text = user.lastName;
    languageListController.setIds(user.langs);
    locationController.value = user.location;
  }

  @override
  AppConfiguration get currentConfiguration => const EditProfileConfiguration();

  @override
  EditProfileScreenCubitState createState() {
    return EditProfileScreenCubitState(
      sex: _sex,
      inProgress: _inProgress,
      canSave: _canSave(),
    );
  }

  bool _canSave() {
    return !_inProgress;
  }

  void setSex(String sex) {
    _sex = sex;
    emitState();
  }

  void save() async {
    _inProgress = true;
    emitState();

    final request = SaveProfileRequest(
      firstName:  firstNameController.text,
      middleName: middleNameController.text,
      lastName:   lastNameController.text,
      sex:        _sex,
      langs:      languageListController.getIds(),
      location:   _getSaveLocationRequest(),
    );

    try {
      await _authenticationCubit.saveProfile(request);
      emitSaved();
      closeScreen();
    } catch (ex) {
      _inProgress = false;
      emitState();
      emitUnknownError();
    }
  }

  SaveLocationRequest? _getSaveLocationRequest() {
    final location = locationController.value;
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
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    languageListController.dispose();
    locationController.dispose();
    super.dispose();
  }
}

class EditProfileScreenCubitState {
  final String sex;
  final bool inProgress;
  final bool canSave;

  const EditProfileScreenCubitState({
    required this.sex,
    required this.inProgress,
    required this.canSave,
  });
}
