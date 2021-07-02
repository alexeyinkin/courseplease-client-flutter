import 'package:courseplease/models/user.dart';
import 'package:courseplease/screens/edit_profile/local_blocs/edit_profile.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/dialog_result.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/sex_input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfile';

  final User user;

  EditProfileScreen({
    required this.user,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState(
    user: user,
  );

  static Future<void> show({
    required BuildContext context,
    required User user,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          user: user,
        ),
      ),
    );
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileScreenCubit _cubit;
  final _formKey = GlobalKey<FormState>();

  _EditProfileScreenState({
    required User user,
  }) :
      _cubit = EditProfileScreenCubit(user: user)
  {
    _cubit.results.listen((result) => popOrShowError(context, result));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditProfileScreenCubitState>(
      stream: _cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(EditProfileScreenCubitState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('EditProfileScreen.title')),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getFirstNameInput(state),
              SmallPadding(),
              _getMiddleNameInput(state),
              SmallPadding(),
              _getLastNameInput(state),
              SmallPadding(),
              _getSexInput(state),
              SmallPadding(),
              _getLanguageListEditor(state),
              SmallPadding(),
              _getSaveButton(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFirstNameInput(EditProfileScreenCubitState state) {
    return AppTextField(
      controller: state.firstNameController,
      labelText: tr('EditProfileScreen.firstName'),
      validator: _notEmpty,
    );
  }

  Widget _getMiddleNameInput(EditProfileScreenCubitState state) {
    return AppTextField(
      controller: state.middleNameController,
      labelText: tr('EditProfileScreen.middleName'),
    );
  }

  Widget _getLastNameInput(EditProfileScreenCubitState state) {
    return AppTextField(
      controller: state.lastNameController,
      labelText: tr('EditProfileScreen.lastName'),
      validator: _notEmpty,
    );
  }

  Widget _getSexInput(EditProfileScreenCubitState state) {
    return SexInputWidget(
      value: state.sex,
      onChanged: _cubit.setSex,
    );
  }

  Widget _getLanguageListEditor(EditProfileScreenCubitState state) {
    return Row(
      children: [
        Text(tr('EditProfileScreen.iSpeak')),
        SmallPadding(),
        Expanded(
          child: LanguageListEditor(
            controller: state.languageListController,
          ),
        ),
      ],
    );
  }

  Widget _getSaveButton(EditProfileScreenCubitState state) {
    return Center(
      child: ElevatedButtonWithProgress(
        onPressed: _save,
        child: Text(tr('common.buttons.save')),
        isLoading: state.inProgress,
        enabled: state.canSave,
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _cubit.save();
    }
  }

  String? _notEmpty(String? value) {
    if (value == null || value == '') return 'Should not be empty.';
    return null;
  }

  @override
  void dispose() {
    _cubit.dispose();
    super.dispose();
  }
}
