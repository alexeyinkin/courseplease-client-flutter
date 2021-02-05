import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/screens/edit_integration/local_widgets/instagram.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EditIntegrationScreen extends StatefulWidget {
  static const routeName = 'editIntegration';

  @override
  State<StatefulWidget> createState() => _EditIntegrationScreenState();
}

class _EditIntegrationScreenState extends State<EditIntegrationScreen> {
  MeResponseData _meResponseData; // Nullable
  EditableContact _contact; // Nullable
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    _loadIfNot();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 20),
              child: AuthProviderIcon(name: _contact.className),
            ),
            Text(
              _contact.getTitle(),
              style: AppStyle.h2,
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _getTokenStatusWidget(),
            _getDownloadNewContentsToggle(),
            _getProviderSettingWidget(),
            _getSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _getTokenStatusWidget() {
    if (_contact.tokenExpire != null) {
      final diff = _contact.tokenExpire.difference(DateTime.now());
      if (diff.isNegative) return _getTokenStatusInvalid();

      final daysLeft = diff.inDays;

      if (daysLeft > 0) return _getTokenStatusDaysLeftWidget(daysLeft);
      return _getTokenStatusExpiresSoon();
    }

    return _getTokenStatusInvalid();
  }

  Widget _getTokenStatusDaysLeftWidget(int daysLeft) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.check_circle, color: Color(0xFF00A000), size: 24),
        ),
        Text("Token is valid for $daysLeft more days."),
      ],
    );
  }

  Widget _getTokenStatusExpiresSoon() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.check_circle, color: Color(0xFF00A000), size: 24),
        ),
        Text("Token is valid and will expire in less than a day."),
      ],
    );
  }

  Widget _getTokenStatusInvalid() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: Icon(Icons.cancel, color: Color(0xFFA00000), size: 24),
        ),
        Text("No token. Authorize the app to download contents."),
      ],
    );
  }

  Widget _getDownloadNewContentsToggle() {
    final serviceName = _contact.getServiceTitle();

    return SwitchListTile(
      title: Text("Download new contents from $serviceName"),
      value: _contact.downloadEnabled,
      onChanged: _handleIsDownloadEnabledToggle,
    );
  }

  void _handleIsDownloadEnabledToggle(bool value) {
    setState(() {
      _contact.downloadEnabled = value;
    });
  }

  Widget _getProviderSettingWidget() {
    if (_contact.params is InstagramContactParams) {
      return InstagramContactParamsWidget(
        meResponseData: _meResponseData,
        params: _contact.params,
      );
    }
    return Container();
  }

  Widget _getSaveButton() {
    return ElevatedButton(
      child: Text("Save"),
      onPressed: _handleSave,
    );
  }

  void _handleSave() {
    final request = SaveContactParamsRequest(
      contactId:        _contact.id,
      downloadEnabled:  _contact.downloadEnabled,
      params:           _contact.params,
    );

    _authenticationCubit.saveContactParams(request);
    Navigator.of(context).pop();
  }

  void _loadIfNot() {
    if (_contact != null) return;

    final arguments = ModalRoute.of(context).settings.arguments as EditIntegrationScreenArguments;
    _meResponseData = arguments.meResponseData;
    _contact = arguments.contact;
  }
}

class EditIntegrationScreenArguments {
  final MeResponseData meResponseData;
  final EditableContact contact;

  EditIntegrationScreenArguments({
    @required this.meResponseData,
    @required this.contact,
  });
}
