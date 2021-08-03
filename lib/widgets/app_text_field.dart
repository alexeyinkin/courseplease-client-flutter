import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final bool enabled;

  AppTextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.multiline,
    this.onTap,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyText1!.color!;

    return TextFormField(
      decoration: getInputDecoration(context: context, hintText: hintText, labelText: labelText),
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      maxLines: maxLines,
      minLines: minLines,
      textAlign: textAlign,
      keyboardType: keyboardType,
      onTap: onTap,
      cursorColor: textColor,
      enabled: enabled,
    );
  }
}
