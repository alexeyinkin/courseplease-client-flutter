import 'package:courseplease/theme/theme.dart';
import 'package:flutter/material.dart';

class EditBodyTabWidget extends StatelessWidget {
  final TextEditingController textEditingController;

  EditBodyTabWidget({
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        controller: textEditingController,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: getInputDecoration(context: context),
        cursorColor: getTextColor(context),
      ),
    );
  }
}
