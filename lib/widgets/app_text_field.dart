import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;

  AppTextField({
    required this.controller,
    this.hintText,
    this.focusNode,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyText1!.color!;
    final borderColor = Color.lerp(textColor, null, .7)!;

    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
      ),
    );

    return TextFormField(
      decoration: new InputDecoration(
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        errorBorder: border,
        disabledBorder: border,
        contentPadding: EdgeInsets.all(10),
        hintText: hintText,
      ),
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: TextInputType.multiline,
      cursorColor: Theme.of(context).textTheme.bodyText1?.color,
    );
  }
}
