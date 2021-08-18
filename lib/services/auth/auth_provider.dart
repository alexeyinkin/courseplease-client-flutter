import 'dart:ui';

import 'package:flutter/widgets.dart';

abstract class AuthProvider {
  final int id;
  final String intName;
  final String title;
  final Color color;

  AuthProvider({
    required this.id,
    required this.intName,
    required this.title,
    required this.color,
  });

  Future<void> authenticate(BuildContext context);
}
