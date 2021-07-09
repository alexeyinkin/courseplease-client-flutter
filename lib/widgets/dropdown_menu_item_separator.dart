import 'package:flutter/material.dart';

class DropdownMenuItemSeparator<T> extends DropdownMenuItem<T> {
  DropdownMenuItemSeparator() : super(child: Container()); // Trick the assertion.

  @override
  Widget build(BuildContext context) {
    return Divider(thickness: 3);
  }
}
