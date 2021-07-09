import 'package:flutter/material.dart';

class AppStyle {
  static const pageTitle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  static const h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const h3 = TextStyle(
    fontSize: 24,
  );

  static const bold = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static const breadcrumbItem = TextStyle(
    fontSize: 36,
  );

  static const breadcrumbItemActive = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
  );

  static const subcategoryItem = TextStyle(
    fontSize: 24,
  );

  static const imageTitle = TextStyle(
    fontSize: 24,
  );

  static const lessonTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const minor = TextStyle(
    fontSize: 10,
  );

  static const italic = TextStyle(
    fontStyle: FontStyle.italic,
  );

  static const unreadColor = Color(0x30808080);
  static const errorColor = Color(0xFFFF0000);
  static const borderColor = Color(0x60808080);
  static const borderRadius = 4.0;
}

Color getTextColor(BuildContext context) {
  return Theme.of(context).textTheme.bodyText1!.color!;
}

InputDecoration getInputDecoration({
  required BuildContext context,
  String? hintText,
  String? labelText,
}) {
  final textColor = getTextColor(context);
  final borderColor = Color.lerp(textColor, null, .7)!;

  final border = OutlineInputBorder(
    borderSide: BorderSide(
      color: borderColor,
    ),
  );

  return InputDecoration(
    border: border,
    focusedBorder: border,
    enabledBorder: border,
    errorBorder: border,
    disabledBorder: border,
    contentPadding: EdgeInsets.all(10),
    hintText: hintText,
    labelText: labelText,
    labelStyle: TextStyle(
      color: borderColor,
    ),
  );
}
