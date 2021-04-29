import 'package:courseplease/blocs/chats.dart';
import 'package:courseplease/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatButton extends StatelessWidget {
  final User user;

  ChatButton({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Icon(Icons.message),
      onPressed: _handlePressed,
    );
  }

  void _handlePressed() {
    final chatsCubit = GetIt.instance.get<ChatsCubit>();
    chatsCubit.showChatWithUser(user);
  }
}
