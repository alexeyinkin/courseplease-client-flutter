import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';

import 'editable_contact.dart';

class InstagramContactParams extends ContactParams {
  InstagramNewPhotoAction newPhotoAction;
  int newPhotoSubjectId; // Nullable

  InstagramContactParams({
    @required this.newPhotoAction,
    @required this.newPhotoSubjectId,
  });

  factory InstagramContactParams.fromMap(Map<String, dynamic> map) {
    InstagramNewPhotoAction action;

    switch (map['newPhotoAction']) {
      case 'portfolio':
        action = InstagramNewPhotoAction.portfolio;
        break;
      default:
        action = InstagramNewPhotoAction.unsorted;
    }

    return InstagramContactParams(
      newPhotoAction: action,
      newPhotoSubjectId: map['newPhotoSubjectId'],
    );
  }

  factory InstagramContactParams.from(InstagramContactParams params) {
    return InstagramContactParams(
      newPhotoAction:     params.newPhotoAction,
      newPhotoSubjectId:  params.newPhotoSubjectId,
    );
  }

  @override
  InstagramContactParams clone() {
    return InstagramContactParams.from(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'newPhotoAction':     enumValueAfterDot(newPhotoAction),
      'newPhotoSubjectId':  newPhotoSubjectId,
    };
  }
}

enum InstagramNewPhotoAction {
  unsorted,
  portfolio,
}
