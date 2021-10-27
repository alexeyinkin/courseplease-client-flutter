import 'package:courseplease/screens/home/local_widgets/my_profile.dart';
import 'package:courseplease/widgets/auth/sign_in_if_not.dart';
import 'package:courseplease/widgets/device_key.dart';
import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SignInIfNotWidget(
            signedInBuilder: (_, __) => MyProfileWidget(),
          ),
        ),
        DeviceKeyWidget(),
      ],
    );
  }
}
