import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/screens/edit_integration/local_blocs/edit_integration.dart';
import 'package:courseplease/models/common.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/instagram.dart';
import 'package:courseplease/models/contact/profile_sync_status.dart';
import 'package:courseplease/screens/edit_integration/local_widgets/instagram.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/contact_title.dart';
import 'package:courseplease/widgets/icon_text_status.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditIntegrationScreen extends StatefulWidget {
  static const routeName = 'editIntegration';

  @override
  State<StatefulWidget> createState() => _EditIntegrationScreenState();
}

class _EditIntegrationScreenState extends State<EditIntegrationScreen> {
  EditableContact _contactClone; // Nullable
  EditIntegrationCubit _editIntegrationCubit; // Nullable

  @override
  Widget build(BuildContext context) {
    _loadIfNot();

    return StreamBuilder(
      stream: _editIntegrationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(EditIntegrationState state) {
    if (state == null) return Container();

    return Scaffold(
      appBar: AppBar(
        title: ContactTitleWidget(contact: _contactClone),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _getTokenStatusWidget(state),
            _buildUpdateStatusWidget(state),
            _getDownloadNewContentsToggle(),
            _getProviderSettingWidget(state.meResponseData),
            _getSaveButton(state),
          ],
        ),
      ),
    );
  }

  Widget _getTokenStatusWidget(EditIntegrationState state) {
    if (state.contact.tokenExpire != null) {
      final diff = state.contact.tokenExpire.difference(DateTime.now());
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

  Widget _buildUpdateStatusWidget(EditIntegrationState state) {
    if (state.contact.profileSyncStatus.dateTimeUpdate == null) {
      return _buildUpdateStatusNeverUpdated(state);
    }

    switch (state.contact.profileSyncStatus.runStatus) {
      case RunStatus.running:
        return _buildUpdateStatusRunning();
      case RunStatus.complete:
        return _buildUpdateStatusComplete(state);
      case RunStatus.error:
        return _buildUpdateStatusError(state);
    }
    return Container();
  }

  Widget _buildUpdateStatusNeverUpdated(EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: AppLocalizations.of(context).editIntegrationNeverUpdated,
      trailing: _buildUpdateAndViewButtons(state),
    );
  }

  Widget _buildUpdateStatusRunning() {
    return IconTextWidget(
      iconName: StatusIconEnum.sync,
      text: AppLocalizations.of(context).editIntegrationSynchronizingNow,
    );
  }

  Widget _buildUpdateStatusComplete(EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.ok,
      text: AppLocalizations.of(context).editIntegrationLastUpdated(_getUpdatedTimeAgo(state.contact.profileSyncStatus)),
      trailing: _buildUpdateAndViewButtons(state),
    );
  }

  Widget _buildUpdateStatusError(EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: AppLocalizations.of(context).editIntegrationErrorLastTried(_getUpdatedTimeAgo(state.contact.profileSyncStatus)),
      trailing: _buildUpdateAndViewButtons(state),
    );
  }

  String _getUpdatedTimeAgo(ProfileSyncStatus status) {
    return formatRoughDuration(
        DateTime.now().difference(status.dateTimeUpdate),
        AppLocalizations.of(context),
    );
  }

  Widget _buildUpdateAndViewButtons(EditIntegrationState state) {
    return Row(
      children: [
        padRight(_buildUpdateNowButton(state)),
        padRight(_buildViewDownloadedButton(state)),
      ]
    );
  }

  Widget _buildUpdateNowButton(EditIntegrationState state) {
    return ElevatedButtonWithProgress(
      child: Text(AppLocalizations.of(context).editIntegrationUpdateNow),
      onPressed: _updateNow,
      isLoading: state.currentAction == EditIntegrationCurrentAction.sync,
      enabled: state.currentAction == EditIntegrationCurrentAction.none,
    );
  }

  void _updateNow() {
    _editIntegrationCubit.synchronize();
  }

  Widget _buildViewDownloadedButton(EditIntegrationState state) {
    return ElevatedButton(
      child: Text("View Images"),
      onPressed: _viewDownloaded,
    );
  }

  void _viewDownloaded() async {
    await Navigator.of(context).pushNamed(
      EditImageListScreen.routeName,
      arguments: EditImageListArguments(
        filter: EditImageFilter(
          contactIds: [_contactClone.id],
        ),
        contactsByIds: {_contactClone.id: _contactClone},
      ),
    );

    // TODO: Reload current actor because there might be no more unsorted images.
  }

  Widget _getDownloadNewContentsToggle() {
    final serviceName = _contactClone.getServiceTitle();

    return SwitchListTile(
      title: Text("Download new contents from $serviceName"),
      value: _contactClone.downloadEnabled,
      onChanged: _handleIsDownloadEnabledToggle,
    );
  }

  void _handleIsDownloadEnabledToggle(bool value) {
    setState(() {
      _contactClone.downloadEnabled = value;
    });
  }

  Widget _getProviderSettingWidget(MeResponseData meResponseData) {
    if (_contactClone.params is InstagramContactParams) {
      return InstagramContactParamsWidget(
        meResponseData: meResponseData,
        params: _contactClone.params,
      );
    }
    return Container();
  }

  Widget _getSaveButton(EditIntegrationState state) {
    return ElevatedButtonWithProgress(
      child: Text("Save"),
      onPressed: _handleSave,
      isLoading: state.currentAction == EditIntegrationCurrentAction.save,
      enabled: state.currentAction == EditIntegrationCurrentAction.none,
    );
  }

  void _handleSave() async {
    final request = SaveContactParamsRequest(
      contactId:        _contactClone.id,
      downloadEnabled:  _contactClone.downloadEnabled,
      params:           _contactClone.params,
    );

    await _editIntegrationCubit.saveContactParams(request);
    Navigator.of(context).pop();
  }

  void _loadIfNot() {
    if (_contactClone != null) return;

    final arguments = ModalRoute.of(context).settings.arguments as EditIntegrationScreenArguments;
    _contactClone = arguments.contactClone;
    _editIntegrationCubit = EditIntegrationCubit(contactId: _contactClone.id);
  }
}

class EditIntegrationScreenArguments {
  final EditableContact contactClone;

  EditIntegrationScreenArguments({
    @required this.contactClone,
  });
}
