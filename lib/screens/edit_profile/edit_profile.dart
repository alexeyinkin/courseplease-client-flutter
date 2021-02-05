import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/language.dart';
import 'package:courseplease/widgets/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get_it/get_it.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = '/editProfile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User _user; // Nullable.
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _loadIfNot();

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

  void _loadIfNot() {
    if (_user == null) {
      final arguments = ModalRoute.of(context).settings.arguments as EditProfileScreenArguments;
      _user = arguments.user;
      _firstNameController.text = _user.firstName;
      _middleNameController.text = _user.middleName;
      _lastNameController.text = _user.lastName;
    }
  }

  Widget _getFirstNameInput() {
    return TextFormField(
      controller: _firstNameController,
      decoration: InputDecoration(
        labelText: 'First Name',
      ),
      validator: _notEmpty,
    );
  }

  Widget _getMiddleNameInput() {
    return TextFormField(
      controller: _middleNameController,
      decoration: InputDecoration(
        labelText: 'Middle Name',
      ),
    );
  }

  Widget _getLastNameInput() {
    return TextFormField(
      controller: _lastNameController,
      decoration: InputDecoration(
        labelText: 'Last Name',
      ),
      validator: _notEmpty,
    );
  }

  Widget _getLangsInput() {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Tags(
        textField: TagsTextField(
          hintText: 'Add a language',
          onSubmitted: _filterAndAddLang,
          constraintSuggestion: true,
          suggestions: ['en', 'ru', 'es'],
        ),
        itemCount: _user.langs.length,
        itemBuilder: (index) {
          final lang = _user.langs[index];
          final removeButton = _user.langs.length == 1
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
            textColor: Color(0xffff0000),
          );
        },
      ),
    );
  }

  void _filterAndAddLang(String lang) {
    final index = _user.langs.indexOf(lang);

    if (index != -1) return;

    setState(() {
      _user.langs.add(lang);
    });
  }

  void _removeLang(String lang) {
    final index = _user.langs.indexOf(lang);

    if (index == -1) return;

    setState(() {
      _user.langs.removeAt(index);
    });
  }

  void _save() {
    if (_formKey.currentState.validate()) {
      final request = SaveProfileRequest(
        firstName:  _firstNameController.text,
        middleName: _middleNameController.text,
        lastName:   _lastNameController.text,
        sex:        _user.sex,
        langs:      _user.langs,
      );

      _authenticationCubit.saveProfile(request);
      Navigator.of(context).pop();
    }
  }

  String _notEmpty(String value) { // Nullable
    if (value == '') return 'Should not be empty.';
    return null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
  }
}

class EditProfileScreenArguments {
  final User user;

  EditProfileScreenArguments({
    @required this.user,
  });
}
