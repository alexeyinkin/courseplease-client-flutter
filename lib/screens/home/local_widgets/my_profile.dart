import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/screens/edit_profile/edit_profile.dart';
import 'package:courseplease/screens/edit_image_list/edit_image_list.dart';
import 'package:courseplease/screens/edit_teaching/edit_teaching.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/auth/sign_out_button.dart';
import 'package:courseplease/widgets/linked_profiles.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/profile.dart';
import 'package:courseplease/widgets/unsorted_media_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class MyProfileWidget extends StatefulWidget {
  @override
  State<MyProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<MyProfileWidget> {
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authenticationCubit.outState,
      initialData: _authenticationCubit.initialState,
      builder: (context, snapshot) => _buildWithState(snapshot.data),
    );
  }

  Widget _buildWithState(AuthenticationState state) {
    if (state.data?.user == null) return Container();
    return _buildWithAuthenticatedState(state);
  }

  Widget _buildWithAuthenticatedState(AuthenticationState state) {
    return Column(
      children: [
        _getProfileWidget(state.data.user),
        _getEditMenu(state.data),
        _getExistingIntegrationsMenu(state.data),
        _getAddIntegrationsMenu(state.data.user),
      ],
    );
  }

  Widget _getProfileWidget(User user) {
    return ProfileWidget(
      user: user,
      childrenUnderUserpic: [
        SignOutButton(),
      ],
      childrenUnderName: [
        _getLocationLine(user),
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
          onTap: () => _editProfile(meResponseData.user),
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
    await Navigator.of(context).pushNamed(
      EditImageListScreen.routeName,
      arguments: EditImageListArguments(
        filter: EditImageFilter(
          unsorted: true,
        ),
      ),
    );

    _authenticationCubit.reloadCurrentActor();
  }

  void _editProfile(User user) {
    Navigator.of(context).pushNamed(
      EditProfileScreen.routeName,
      arguments: EditProfileScreenArguments(
        user: User.from(user),
      ),
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

  Widget _getAddIntegrationsMenu(User user) {
    return Container();
  }
}
