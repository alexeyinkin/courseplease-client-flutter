import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/widgets/linked_profile.dart';
import 'package:flutter/widgets.dart';

class LinkedProfilesWidget extends StatelessWidget {
  final MeResponseData meResponseData;

  LinkedProfilesWidget({
    @required this.meResponseData,
  });

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (final contact in meResponseData.contacts) {
      if (!LinkedProfileWidget.shouldShow(contact)) continue;

      children.add(
        LinkedProfileWidget(
          meResponseData: meResponseData,
          contact: contact,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
