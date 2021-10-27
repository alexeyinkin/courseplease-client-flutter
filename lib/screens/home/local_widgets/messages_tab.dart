import 'package:courseplease/widgets/auth/sign_in_if_not.dart';
import 'package:courseplease/widgets/messaging/chats.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MessagesTab extends StatefulWidget {
  @override
  State<MessagesTab> createState() => MessagesTabState();
}

class MessagesTabState extends State<MessagesTab> {
  @override
  Widget build(BuildContext context) {
    return SignInIfNotWidget(
      signedInBuilder: (_, __) => ChatsWidget(),
      titleText: tr('MessagesTabWidget.unauthenticatedTitle'),
    );
  }
}
