import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';

import 'interfaces.dart';
import 'location.dart';

class User implements WithId<int> {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final Map<String, String> userpicUrls;
  final Location location;
  final String bio;

  User({
    @required this.id,
    @required this.firstName,
    @required this.middleName,
    @required this.lastName,
    @required this.userpicUrls,
    @required this.location,
    @required this.bio,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id:           map['id'],
      firstName:    map['firstName'],
      middleName:   map['middleName'],
      lastName:     map['lastName'],
      userpicUrls:  toStringStringMap(map['userpicUrls']),
      location:     Location.fromMap(map['location']),
      bio:          map['bio'] ?? '',
    );
  }
}
