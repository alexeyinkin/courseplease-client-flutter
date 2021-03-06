import 'package:courseplease/utils/utils.dart';
import 'editable_contact.dart';

class InstagramContactParams extends ContactParams {
  InstagramNewImageAction newImageAction;
  int? newImageSubjectId;

  InstagramContactParams({
    required this.newImageAction,
    required this.newImageSubjectId,
  });

  factory InstagramContactParams.fromMap(Map<String, dynamic> map) {
    InstagramNewImageAction action;

    switch (map['newImageAction']) {
      case 'portfolio':
        action = InstagramNewImageAction.portfolio;
        break;
      default:
        action = InstagramNewImageAction.unsorted;
    }

    return InstagramContactParams(
      newImageAction: action,
      newImageSubjectId: map['newImageSubjectId'],
    );
  }

  factory InstagramContactParams.from(InstagramContactParams params) {
    return InstagramContactParams(
      newImageAction:     params.newImageAction,
      newImageSubjectId:  params.newImageSubjectId,
    );
  }

  @override
  InstagramContactParams clone() {
    return InstagramContactParams.from(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'newImageAction':     enumValueAfterDot(newImageAction),
      'newImageSubjectId':  newImageSubjectId,
    };
  }
}

enum InstagramNewImageAction {
  unsorted,
  portfolio,
}
