import 'package:courseplease/widgets/messaging/chats.dart';
import 'package:courseplease/widgets/auth/authenticated_or_not.dart';
import 'package:flutter/material.dart';

class MessagesTab extends StatefulWidget {
  @override
  State<MessagesTab> createState() => MessagesTabState();
}

class MessagesTabState extends State<MessagesTab> {
  @override
  Widget build(BuildContext context) {
    return AuthenticatedOrNotWidget(
      authenticatedBuilder: (_) => ChatsWidget(),
      notAuthenticatedBuilder: (_) => Text("Not Authenticated"), // TODO: Make a widget
    );
  }
}
