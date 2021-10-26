import 'package:courseplease/models/contact/contact_class_enum.dart';
import 'package:model_interfaces/model_interfaces.dart';

class Contact implements WithId<int> {
  final int id;
  final String className;
  final String value;
  final String username;

  Contact({
    required this.id,
    required this.className,
    required this.value,
    required this.username,
  });

  String getTitle() {
    if (username != '') return username;
    return value;
  }

  String getServiceTitle() {
    // TODO: Localize.
    switch (className) {
      case ContactClassEnum.facebook:  return 'Facebook';
      case ContactClassEnum.instagram: return 'Instagram';
      case ContactClassEnum.vk:        return 'VK';
    }

    return className;
  }
}
