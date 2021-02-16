import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/common.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/screens/edit_integration/local_widgets/instagram.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/auth/auth_provider_icon.dart';
import 'package:courseplease/widgets/icon_text_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            _buildUpdateStatusWidget(),
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
    return IconTextWidget(
      iconName: StatusIconEnum.ok,
      text: "Token is valid for $daysLeft more days.",
    );
  }

  Widget _getTokenStatusExpiresSoon() {
    return IconTextWidget(
      iconName: StatusIconEnum.ok,
      text: "Token is valid and will expire in less than a day.",
    );
  }

  Widget _getTokenStatusInvalid() {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: "No token. Authorize the app to download contents.",
      // TODO: Add a button to re-authorize.
    );
  }

  Widget _buildUpdateStatusWidget() {
    if (_contact.profileSyncStatus == null || _contact.profileSyncStatus.dateTimeUpdate == null) {
      return _buildUpdateStatusNeverUpdated();
    }

    switch (_contact.profileSyncStatus.runStatus) {
      case RunStatus.running:
        return _buildUpdateStatusRunning();
      case RunStatus.complete:
        return _buildUpdateStatusComplete();
      case RunStatus.error:
        return _buildUpdateStatusError();
    }
    return Container();
  }

  Widget _buildUpdateStatusNeverUpdated() {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: AppLocalizations.of(context).editIntegrationNeverUpdated,
      trailing: _buildUpdateNowButton(),
    );
  }

  Widget _buildUpdateStatusRunning() {
    return IconTextWidget(
      iconName: StatusIconEnum.sync,
      text: AppLocalizations.of(context).editIntegrationSynchronizingNow,
    );
  }

  Widget _buildUpdateStatusComplete() {
    return IconTextWidget(
      iconName: StatusIconEnum.ok,
      text: AppLocalizations.of(context).editIntegrationLastUpdated(_getUpdatedTimeAgo()),
      trailing: _buildUpdateNowButton(),
    );
  }

  Widget _buildUpdateStatusError() {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: AppLocalizations.of(context).editIntegrationErrorLastTried(_getUpdatedTimeAgo()),
      trailing: _buildUpdateNowButton(),
    );
  }

  String _getUpdatedTimeAgo() {
    return formatRoughDuration(
        DateTime.now().difference(_contact.profileSyncStatus.dateTimeUpdate),
        AppLocalizations.of(context),
    );
  }

  Widget _buildUpdateNowButton() {
    return ElevatedButton(
      onPressed: _updateNow,
      child: Text(AppLocalizations.of(context).editIntegrationUpdateNow),
    );
  }

  void _updateNow() {

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
