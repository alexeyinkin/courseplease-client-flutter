import 'package:courseplease/widgets/pad.dart';
import 'package:easy_localization/easy_localization.dart';
import '../fitted_icon_text.dart';
import 'package:flutter/widgets.dart';

class SelectChatPlaceholderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext) {
    return Column(
      children: [
        Expanded(
          child: FittedIconTextWidget(
            text: tr('SelectChatPlaceholderWidget.text'),
          ),
        ),
        HorizontalLine(),
      ],
    );
  }
}
