import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/screens/edit_integration/local_blocs/edit_integration.dart';
import 'package:courseplease/models/common.dart';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/contact/profile_sync_status.dart';
import 'package:courseplease/widgets/builders/factories/contact_params_widget_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/buttons.dart';
import 'package:courseplease/widgets/contact_title.dart';
import 'package:courseplease/widgets/icon_text_status.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class EditIntegrationScreen extends StatefulWidget {
  static const routeName = 'editIntegration';

  final EditableContact contactClone;

  EditIntegrationScreen({
    required this.contactClone,
  });

  @override
  State<StatefulWidget> createState() => _EditIntegrationScreenState(
    contactClone: contactClone,
  );

  static Future<void> show({
    required BuildContext context,
    required EditableContact contactClone,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => EditIntegrationScreen(
          contactClone: contactClone,
        ),
      ),
    );
  }
}

class _EditIntegrationScreenState extends State<EditIntegrationScreen> {
  final EditableContact contactClone;
  final EditIntegrationCubit _editIntegrationCubit;
  final _contactParamsWidgetFactory = GetIt.instance.get<ContactParamsWidgetFactory>();

  _EditIntegrationScreenState({
    required this.contactClone,
  }) :
      _editIntegrationCubit = EditIntegrationCubit(contactId: contactClone.id)
  ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditIntegrationState>(
      stream: _editIntegrationCubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(EditIntegrationState? state) {
    if (state == null) return Container();

    return Scaffold(
      appBar: AppBar(
        title: ContactTitleWidget(contact: contactClone),
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
      final diff = state.contact.tokenExpire!.difference(DateTime.now());
      if (diff.isNegative) return _getTokenStatusInvalid();

      return _getTokenIsValidForWidget(diff);
    }

    return _getTokenStatusInvalid();
  }

  Widget _getTokenIsValidForWidget(Duration duration) {
    final durationValidFor = formatLongRoughDurationValidFor(duration);
    return IconTextWidget(
      iconName: StatusIconEnum.ok,
      text: tr('EditIntegrationScreen.tokenIsValidFor', namedArgs: {'durationValidFor': durationValidFor}),
    );
  }

  Widget _getTokenStatusInvalid() {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: tr('EditIntegrationScreen.noToken'),
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
      text: tr('EditIntegrationScreen.imagesNeverSynchronized'),
      trailing: _buildUpdateAndViewButtons(state),
    );
  }

  Widget _buildUpdateStatusRunning() {
    return IconTextWidget(
      iconName: StatusIconEnum.sync,
      text: tr('EditIntegrationScreen.synchronizingNow'),
    );
  }

  Widget _buildUpdateStatusComplete(EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.ok,
      text: tr('EditIntegrationScreen.lastSynchronized', namedArgs:{'durationAgo': _getUpdatedTimeAgo(state.contact.profileSyncStatus)}),
      trailing: _buildUpdateAndViewButtons(state),
    );
  }

  Widget _buildUpdateStatusError(EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: tr('EditIntegrationScreen.errorLastTried', namedArgs:{'durationAgo': _getUpdatedTimeAgo(state.contact.profileSyncStatus)}),
      trailing: _buildUpdateAndViewButtons(state),
    );
  }

  String _getUpdatedTimeAgo(ProfileSyncStatus status) {
    if (status.dateTimeUpdate == null) {
      throw Exception('dateTimeUpdate is required for status ' + status.runStatus.toString());
    }
    return formatLongRoughDurationAgo(
      DateTime.now().difference(status.dateTimeUpdate!),
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
      child: Text(tr('EditIntegrationScreen.buttons.synchronizeNow')),
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
      child: Text(tr('EditIntegrationScreen.buttons.viewImages')),
      onPressed: _viewDownloaded,
    );
  }

  void _viewDownloaded() async {
    EditImageListScreen.show(
      context: context,
      filter: MyImageFilter(
        contactIds: [contactClone.id],
      ),
      contactsByIds: {contactClone.id: contactClone},
    );

    // TODO: Reload current actor because there might appear no more unsorted images.
  }

  Widget _getDownloadNewContentsToggle() {
    final serviceName = contactClone.getServiceTitle();

    return SwitchListTile(
      title: Text(tr('EditIntegrationScreen.downloadNewContentFrom', namedArgs: {'serviceName': serviceName})),
      value: contactClone.downloadEnabled,
      onChanged: _handleIsDownloadEnabledToggle,
    );
  }

  void _handleIsDownloadEnabledToggle(bool value) {
    setState(() {
      contactClone.downloadEnabled = value;
    });
  }

  Widget _getProviderSettingWidget(MeResponseData meResponseData) {
    return _contactParamsWidgetFactory.createWidget(
      meResponseData: meResponseData,
      contact: contactClone,
    );
  }

  Widget _getSaveButton(EditIntegrationState state) {
    return ElevatedButtonWithProgress(
      child: Text(tr('common.buttons.save')),
      onPressed: _handleSave,
      isLoading: state.currentAction == EditIntegrationCurrentAction.save,
      enabled: state.currentAction == EditIntegrationCurrentAction.none,
    );
  }

  void _handleSave() async {
    final request = SaveContactParamsRequest(
      contactId:        contactClone.id,
      downloadEnabled:  contactClone.downloadEnabled,
      params:           contactClone.params,
    );

    await _editIntegrationCubit.saveContactParams(request);
    Navigator.of(context).pop();
  }
}
