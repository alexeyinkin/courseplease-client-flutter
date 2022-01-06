import 'package:courseplease/screens/edit_profile/bloc.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/app_text_field.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/frames/framed_column.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:courseplease/widgets/location_editor.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/sex_input.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'bloc.dart';

class EditProfileScreen extends StatelessWidget {
  final EditProfileBloc bloc;

  EditProfileScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditProfileScreenCubitState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(EditProfileScreenCubitState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('EditProfileScreen.title')),
      ),
      body: Form(
        key: bloc.formKey,
        child: FramedColumn(
          children: [
            SmallPadding(),
            _getFirstNameInput(state),
            SmallPadding(),
            _getMiddleNameInput(state),
            SmallPadding(),
            _getLastNameInput(state),
            SmallPadding(),
            _getSexInput(state),
            SmallPadding(),
            _getLanguageListEditor(state),
            Container(height: 30),
            _getLocationEditor(state),
            SmallPadding(),
            _getSaveButton(state),
            SmallPadding(),
          ],
        ),
      ),
    );
  }

  Widget _getFirstNameInput(EditProfileScreenCubitState state) {
    return AppTextField(
      controller: bloc.firstNameController,
      labelText: tr('EditProfileScreen.firstName'),
      validator: _notEmpty,
    );
  }

  Widget _getMiddleNameInput(EditProfileScreenCubitState state) {
    return AppTextField(
      controller: bloc.middleNameController,
      labelText: tr('EditProfileScreen.middleName'),
    );
  }

  Widget _getLastNameInput(EditProfileScreenCubitState state) {
    return AppTextField(
      controller: bloc.lastNameController,
      labelText: tr('EditProfileScreen.lastName'),
      validator: _notEmpty,
    );
  }

  Widget _getSexInput(EditProfileScreenCubitState state) {
    return SexInputWidget(
      value: state.sex,
      onChanged: bloc.setSex,
    );
  }

  Widget _getLanguageListEditor(EditProfileScreenCubitState state) {
    return Row(
      children: [
        Text(tr('EditProfileScreen.iSpeak')),
        SmallPadding(),
        Expanded(
          child: LanguageListEditor(
            controller: bloc.languageListController,
          ),
        ),
      ],
    );
  }

  Widget _getLocationEditor(EditProfileScreenCubitState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('EditProfileScreen.location'),
          style: AppStyle.h2,
        ),
        SmallPadding(),
        LocationEditorWidget(
          controller: bloc.locationController,
          showStreetAddress: true,
          showMap: true,
          showPrivacy: true,
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
    if (bloc.formKey.currentState!.validate()) {
      bloc.save();
    }
  }

  String? _notEmpty(String? value) {
    if (value == null || value == '') return 'Should not be empty.';
    return null;
  }
}
