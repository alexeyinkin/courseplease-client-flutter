import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/language.dart';
import 'package:courseplease/widgets/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get_it/get_it.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfile';

  final User userClone;

  EditProfileScreen({
    required this.userClone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState(
    userClone: userClone,
  );

  static Future<void> show({
    required BuildContext context,
    required User userClone,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userClone: userClone,
        ),
      ),
    );
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final User userClone;
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  _EditProfileScreenState({
    required this.userClone,
  }) {
    _firstNameController.text = userClone.firstName;
    _middleNameController.text = userClone.middleName;
    _lastNameController.text = userClone.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getFirstNameInput(),
              _getMiddleNameInput(),
              _getLastNameInput(),
              _getLangsInput(),
              ElevatedButton(onPressed: _save, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFirstNameInput() {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: tr('EditProfileScreen.firstName'),
      ),
      validator: _notEmpty,
    );
  }

  Widget _getMiddleNameInput() {
    return TextFormField(
      controller: _middleNameController,
      decoration: InputDecoration(
        labelText: tr('EditProfileScreen.middleName'),
      ),
    );
  }

  Widget _getLastNameInput() {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: tr('EditProfileScreen.lastName'),
      ),
      validator: _notEmpty,
    );
  }

  Widget _getLangsInput() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Tags(
        textField: TagsTextField(
          hintText: tr('EditProfileScreen.addLanguage'),
          onSubmitted: _filterAndAddLang,
          constraintSuggestion: true,
          suggestions: ['en', 'ru', 'es'], // TODO: All languages
        ),
        itemCount: userClone.langs.length,
        itemBuilder: (index) {
          final lang = userClone.langs[index];
          final removeButton = userClone.langs.length == 1
              ? null
              : ItemTagsRemoveButton(onRemoved: () {_removeLang(lang); return true;});

          return ItemTags(
            key: ValueKey('lang-' + lang),
            index: index,
            title: getLanguageName(lang) ?? lang,
            image: ItemTagsImage(
              child: LanguageWidget(lang: lang),
            ),
            removeButton: removeButton,
            color: Color(0x40808080),
            textColor: Color(0xffff0000), // TODO: Use theme colors
          );
        },
      ),
    );
  }

  void _filterAndAddLang(String lang) {
    final index = userClone.langs.indexOf(lang);

    if (index != -1) return;

    setState(() {
      userClone.langs.add(lang);
    });
  }

  void _removeLang(String lang) {
    final index = userClone.langs.indexOf(lang);

    if (index == -1) return;

    setState(() {
      userClone.langs.removeAt(index);
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final request = SaveProfileRequest(
        firstName:  _firstNameController.text,
        middleName: _middleNameController.text,
        lastName:   _lastNameController.text,
        sex:        userClone.sex,
        langs:      userClone.langs,
      );

      _authenticationCubit.saveProfile(request);
      Navigator.of(context).pop();
    }
  }

  String? _notEmpty(String? value) {
    if (value == null || value == '') return 'Should not be empty.';
    return null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
  }
}
