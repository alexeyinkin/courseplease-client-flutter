import 'package:flutter/material.dart';

class DropdownMenuItemSeparator<T> extends DropdownMenuItem<T> {
  DropdownMenuItemSeparator() : super(child: Container(), enabled: false);

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 3);
  }
}
