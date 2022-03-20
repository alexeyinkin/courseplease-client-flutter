import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/screens/edit_integration/bloc.dart';
import 'package:courseplease/models/common.dart';
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

class EditIntegrationScreen extends StatelessWidget {
  final EditIntegrationBloc bloc;

  EditIntegrationScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EditIntegrationState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data),
    );
  }

  Widget _buildWithState(BuildContext context, EditIntegrationState? state) {
    if (state == null) return Container();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: bloc.closeScreen),
        title: ContactTitleWidget(contact: bloc.contactClone),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _getTokenStatusWidget(state),
            _buildUpdateStatusWidget(context, state),
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

  Widget _buildUpdateStatusWidget(BuildContext context, EditIntegrationState state) {
    if (state.contact.profileSyncStatus.dateTimeUpdate == null) {
      return _buildUpdateStatusNeverUpdated(context, state);
    }

    switch (state.contact.profileSyncStatus.runStatus) {
      case RunStatus.running:
        return _buildUpdateStatusRunning();
      case RunStatus.complete:
        return _buildUpdateStatusComplete(context, state);
      case RunStatus.error:
        return _buildUpdateStatusError(context, state);
    }
    return Container();
  }

  Widget _buildUpdateStatusNeverUpdated(BuildContext context, EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: tr('EditIntegrationScreen.imagesNeverSynchronized'),
      trailing: _buildUpdateAndViewButtons(context, state),
    );
  }

  Widget _buildUpdateStatusRunning() {
    return IconTextWidget(
      iconName: StatusIconEnum.sync,
      text: tr('EditIntegrationScreen.synchronizingNow'),
    );
  }

  Widget _buildUpdateStatusComplete(BuildContext context, EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.ok,
      text: tr('EditIntegrationScreen.lastSynchronized', namedArgs:{'durationAgo': _getUpdatedTimeAgo(state.contact.profileSyncStatus)}),
      trailing: _buildUpdateAndViewButtons(context, state),
    );
  }

  Widget _buildUpdateStatusError(BuildContext context, EditIntegrationState state) {
    return IconTextWidget(
      iconName: StatusIconEnum.error,
      text: tr('EditIntegrationScreen.errorLastTried', namedArgs:{'durationAgo': _getUpdatedTimeAgo(state.contact.profileSyncStatus)}),
      trailing: _buildUpdateAndViewButtons(context, state),
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

  Widget _buildUpdateAndViewButtons(BuildContext context, EditIntegrationState state) {
    return Row(
      children: [
        padRight(_buildUpdateNowButton(state)),
        padRight(_buildViewDownloadedButton(context, state)),
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
    bloc.synchronize();
  }

  Widget _buildViewDownloadedButton(BuildContext context, EditIntegrationState state) {
    return ElevatedButton(
      child: Text(tr('EditIntegrationScreen.buttons.viewImages')),
      onPressed: () => _viewDownloaded(context),
    );
  }

  void _viewDownloaded(BuildContext context) async {
    EditImageListScreen.show(
      context: context,
      filter: MyImageFilter(
        contactIds: [bloc.contactClone.id],
      ),
      contactsByIds: {bloc.contactClone.id: bloc.contactClone},
    );

    // TODO: Reload current actor because there might appear no more unsorted images.
  }

  Widget _getDownloadNewContentsToggle() {
    final serviceName = bloc.contactClone.getServiceTitle();

    return SwitchListTile(
      title: Text(tr('EditIntegrationScreen.downloadNewContentFrom', namedArgs: {'serviceName': serviceName})),
      value: bloc.contactClone.downloadEnabled,
      onChanged: bloc.setDownloadEnabled,
    );
  }

  Widget _getProviderSettingWidget(MeResponseData meResponseData) {
    return GetIt.instance.get<ContactParamsWidgetFactory>().createWidget(
      editIntegrationBloc: bloc,
      meResponseData: meResponseData,
      contact: bloc.contactClone,
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

  void _handleSave() {
    final request = SaveContactParamsRequest(
      contactId:        bloc.contactClone.id,
      downloadEnabled:  bloc.contactClone.downloadEnabled,
      params:           bloc.contactClone.params,
    );

    bloc.saveContactParams(request);
  }
}
