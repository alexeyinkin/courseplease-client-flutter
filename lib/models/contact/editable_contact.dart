import 'package:courseplease/models/contact/contact.dart';
import 'package:courseplease/models/contact/instagram.dart';
import 'package:meta/meta.dart';

class EditableContact extends Contact {
  bool downloadEnabled;
  final DateTime tokenExpire; // Nullable.
  final ContactParams params;

  EditableContact({
    @required int id,
    @required String className,
    @required String value,
    @required String username,
    @required this.downloadEnabled,
    @required this.tokenExpire,
    @required this.params,
  }) : super(
    id:         id,
    className:  className,
    value:      value,
    username:   username,
  );

  factory EditableContact.fromMap(Map<String, dynamic> map) {
    final className = map['class'];
    final tokenExpireString = map['tokenExpire'];

    return EditableContact(
      id:               map['id'],
      className:        className,
      value:            map['value'],
      username:         map['username'],
      downloadEnabled:  map['downloadEnabled'],
      tokenExpire:      tokenExpireString == null ? null : DateTime.parse(tokenExpireString),
      params:           ContactParamsFactory.create(className, map['params']),
    );
  }

  static List<EditableContact> fromMaps(List list) {
    final castList = list.cast<Map<String, dynamic>>();
    final result = <EditableContact>[];

    for (final map in castList) {
      result.add(EditableContact.fromMap(map));
    }

    return result;
  }

  factory EditableContact.from(EditableContact contact) {
    return EditableContact(
      id:               contact.id,
      className:        contact.className,
      value:            contact.value,
      username:         contact.username,
      downloadEnabled:  contact.downloadEnabled,
      tokenExpire:      contact.tokenExpire,
      params:           contact.params.clone(),
    );
  }
}

class ContactParams {
  ContactParams();

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>();
  }

  factory ContactParams.from(ContactParams params) {
    return ContactParams();
  }

  ContactParams clone() {
    return ContactParams.from(this);
  }
}

class ContactParamsFactory {
  static ContactParams create(String className, mapOrList) {
    final map = mapOrList is List ? Map<String, dynamic>() : mapOrList.cast<String, dynamic>();

    switch (className) {
      case 'instagram':
        return InstagramContactParams.fromMap(map);
    }

    return ContactParams();
  }
}
