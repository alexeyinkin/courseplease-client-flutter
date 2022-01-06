import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/edit_profile/page.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/screens/edit_teaching/page.dart';
import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/auth/auth_provider_icons.dart';
import 'package:courseplease/widgets/auth/auth_providers.dart';
import 'package:courseplease/widgets/auth/sign_in_if_not.dart';
import 'package:courseplease/widgets/auth/sign_out_button.dart';
import 'package:courseplease/widgets/device_key.dart';
import 'package:courseplease/widgets/linked_profiles.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/profile.dart';
import 'package:courseplease/widgets/shop/money_accounts.dart';
import 'package:courseplease/widgets/unsorted_media_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'bloc.dart';

class MyProfileScreen extends StatelessWidget {
  final MyProfileBloc bloc;

  MyProfileScreen({
    required this.bloc,
  });

  // TODO: Move authentication check to the bloc.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SignInIfNotWidget(
            signedInBuilder: (_, __) => _buildAuthenticated(),
          ),
        ),
        DeviceKeyWidget(),
      ],
    );
  }

  Widget _buildAuthenticated() {
    return StreamBuilder<MyProfileCubitState>(
      stream: bloc.states,
      builder: (context, snapshot) => _buildWithState(context, snapshot.data ?? bloc.initialState),
    );
  }

  Widget _buildWithState(BuildContext context, MyProfileCubitState state) {
    if (state.meResponseData?.user == null) return Container();
    return _buildWithAuthenticatedState(context, state);
  }

  Widget _buildWithAuthenticatedState(BuildContext context, MyProfileCubitState state) {
    final data = state.meResponseData!;

    return ListView(
      children: [
        _getProfileWidget(data),
        _getEditMenu(context, data),
        _getExistingIntegrationsMenu(data),
        _getAddIntegrationsMenu(context, state),
      ],
    );
  }

  Widget _getProfileWidget(MeResponseData meResponseData) {
    return ProfileWidget(
      user: meResponseData.user!,
      childrenUnderUserpic: [
        SignOutButton(),
      ],
      childrenUnderName: [
        MoneyAccountsWidget(accounts: meResponseData.moneyAccounts),
        SmallPadding(),
        _getLocationLine(meResponseData.user!),
      ],
    );
  }

  Widget _getLocationLine(User user) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: LocationLineWidget(location: user.location),
    );
  }

  Widget _getEditMenu(BuildContext context, MeResponseData meResponseData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('MyProfileWidget.edit'),
          style: AppStyle.h2,
        ),
        _getSortUnsortedMenuItemIfShould(context, meResponseData),
        ListTile(
          title: Text(tr('MyProfileWidget.myProfile')),
          trailing: Icon(Icons.chevron_right),
          onTap: _editProfile,
        ),
        ListTile(
          title: Text(tr('MyProfileWidget.myTeaching')),
          trailing: Icon(Icons.chevron_right),
          onTap: _editTeaching,
        ),
      ],
    );
  }

  Widget _getSortUnsortedMenuItemIfShould(BuildContext context, MeResponseData meResponseData) {
    if (!meResponseData.hasUnsortedMedia) return Container();

    return ListTile(
      title: Text(tr('MyProfileWidget.sortImportedMedia')),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            child: UnsortedMediaPreviewWidget(),
            width: 150,
            height: 40,
          ),
          Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => _sortUnsortedMedia(context),
    );
  }

  void _sortUnsortedMedia(BuildContext context) async {
    await EditImageListScreen.show(
      context: context,
      filter: MyImageFilter(
        unsorted: true,
      ),
    );

    bloc.reloadCurrentActor();
  }

  void _editProfile() {
    GetIt.instance.get<AppState>().pushPage(
      EditProfilePage(),
    );
  }

  void _editTeaching() {
    GetIt.instance.get<AppState>().pushPage(EditTeachingPage());
  }

  Widget _getExistingIntegrationsMenu(MeResponseData data) {
    if (data.contacts.length == 0) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('MyProfileWidget.linkedProfiles'),
          style: AppStyle.h2,
        ),
        LinkedProfilesWidget(meResponseData: data),
      ]
    );
  }

  Widget _getAddIntegrationsMenu(BuildContext context, MyProfileCubitState state) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getAddSuggestedIntegrationsMenu(context, state.suggestedAuthProviders),
          SmallPadding(),
          SmallPadding(),
          _getAddIntegrationsExpandableMenu(context, state),
        ],
      ),
    );
  }

  Widget _getAddSuggestedIntegrationsMenu(BuildContext context, List<AuthProvider> providers) {
    return AuthProvidersWidget(
      providers: providers,
      titleTemplate: tr('MyProfileWidget.connect'),
      onTap: (provider) => _onConnectTap(context, provider),
    );
  }

  Widget _getAddIntegrationsExpandableMenu(BuildContext context, MyProfileCubitState state) {
    return state.connectAccountsExpanded
        ? _getAddIntegrationsExpandedMenu(context, state.otherAuthProviders)
        : _getAddIntegrationsCollapsedMenu();
  }

  Widget _getAddIntegrationsExpandedMenu(BuildContext context, List<AuthProvider> providers) {
    return AuthProviderIconsWidget(
      providers: providers,
      leadingIfNotEmpty: GestureDetector(
        onTap: bloc.toggleMore,
        child: Text(tr('MyProfileWidget.connectMore')),
      ),
      scale: .7,
      onTap: (provider) => _onConnectTap(context, provider),
    );
  }

  Widget _getAddIntegrationsCollapsedMenu() {
    return GestureDetector(
      onTap: bloc.toggleMore,
      child: Text(tr('common.more')),
    );
  }

  void _onConnectTap(BuildContext context, AuthProvider provider) {
    bloc.requestAuthorization(context, provider);
  }
}
