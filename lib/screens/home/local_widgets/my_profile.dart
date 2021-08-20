import 'package:courseplease/models/filters/my_image.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/screens/edit_profile/edit_profile.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/screens/edit_teaching/edit_teaching.dart';
import 'package:courseplease/screens/home/local_blocs/my_profile.dart';
import 'package:courseplease/services/auth/auth_provider.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/auth/auth_provider_icons.dart';
import 'package:courseplease/widgets/auth/auth_providers.dart';
import 'package:courseplease/widgets/auth/sign_out_button.dart';
import 'package:courseplease/widgets/linked_profiles.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/profile.dart';
import 'package:courseplease/widgets/shop/money_accounts.dart';
import 'package:courseplease/widgets/unsorted_media_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyProfileWidget extends StatefulWidget {
  @override
  State<MyProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<MyProfileWidget> {
  final _cubit = MyProfileCubit();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MyProfileCubitState>(
      stream: _cubit.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(MyProfileCubitState state) {
    if (state.meResponseData?.user == null) return Container();
    return _buildWithAuthenticatedState(state);
  }

  Widget _buildWithAuthenticatedState(MyProfileCubitState state) {
    final data = state.meResponseData!;

    return ListView(
      children: [
        _getProfileWidget(data),
        _getEditMenu(data),
        _getExistingIntegrationsMenu(data),
        _getAddIntegrationsMenu(state),
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

  Widget _getEditMenu(MeResponseData meResponseData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('MyProfileWidget.edit'),
          style: AppStyle.h2,
        ),
        _getSortUnsortedMenuItemIfShould(meResponseData),
        ListTile(
          title: Text(tr('MyProfileWidget.myProfile')),
          trailing: Icon(Icons.chevron_right),
          onTap: () => _editProfile(meResponseData.user!),
        ),
        ListTile(
          title: Text(tr('MyProfileWidget.myTeaching')),
          trailing: Icon(Icons.chevron_right),
          onTap: () => _editTeaching(),
        ),
      ],
    );
  }

  Widget _getSortUnsortedMenuItemIfShould(MeResponseData meResponseData) {
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
      onTap: () => _sortUnsortedMedia(),
    );
  }

  void _sortUnsortedMedia() async {
    await EditImageListScreen.show(
      context: context,
      filter: MyImageFilter(
        unsorted: true,
      ),
    );

    _cubit.reloadCurrentActor();
  }

  void _editProfile(User user) {
    EditProfileScreen.show(
      context: context,
      user: user,
    );
  }

  void _editTeaching() {
    Navigator.of(context).pushNamed(
      EditTeachingScreen.routeName,
    );
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

  Widget _getAddIntegrationsMenu(MyProfileCubitState state) {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getAddSuggestedIntegrationsMenu(state.suggestedAuthProviders),
          SmallPadding(),
          SmallPadding(),
          _getAddIntegrationsExpandableMenu(state),
        ],
      ),
    );
  }

  Widget _getAddSuggestedIntegrationsMenu(List<AuthProvider> providers) {
    return AuthProvidersWidget(
      providers: providers,
      titleTemplate: tr('MyProfileWidget.connect'),
      onTap: _onConnectTap,
    );
  }

  Widget _getAddIntegrationsExpandableMenu(MyProfileCubitState state) {
    return state.connectAccountsExpanded
        ? _getAddIntegrationsExpandedMenu(state.otherAuthProviders)
        : _getAddIntegrationsCollapsedMenu();
  }

  Widget _getAddIntegrationsExpandedMenu(List<AuthProvider> providers) {
    return AuthProviderIconsWidget(
      providers: providers,
      leadingIfNotEmpty: GestureDetector(
        onTap: _cubit.toggleMore,
        child: Text(tr('MyProfileWidget.connectMore')),
      ),
      scale: .7,
      onTap: _onConnectTap,
    );
  }

  Widget _getAddIntegrationsCollapsedMenu() {
    return GestureDetector(
      onTap: _cubit.toggleMore,
      child: Text(tr('common.more')),
    );
  }

  void _onConnectTap(AuthProvider provider) {
    _cubit.requestAuthorization(context, provider);
  }
}
