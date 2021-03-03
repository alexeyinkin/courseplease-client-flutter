import 'package:flutter/material.dart';

class EditBodyTabWidget extends StatelessWidget {
  final TextEditingController textEditingController; // Nullable

  EditBodyTabWidget({
    @required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }
}
