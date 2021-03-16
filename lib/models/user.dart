import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';

import 'interfaces.dart';
import 'location.dart';

class User implements WithId<int> {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String sex;
  final List<String> langs;
  final Map<String, String> userpicUrls;
  final Location location;
  final String bio;

  User({
    @required this.id,
    @required this.firstName,
    @required this.middleName,
    @required this.lastName,
    @required this.sex,
    @required this.langs,
    @required this.userpicUrls,
    @required this.location,
    @required this.bio,
  });

  factory User.from(User user) {
    return User(
      id:           user.id,
      firstName:    user.firstName,
      middleName:   user.middleName,
      lastName:     user.lastName,
      sex:          user.sex,
      langs:        List<String>.from(user.langs),
      userpicUrls:  Map<String, String>.from(user.userpicUrls),
      location:     Location.from(user.location),
    );
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id:           map['id'],
      firstName:    map['firstName'],
      middleName:   map['middleName'],
      lastName:     map['lastName'],
      sex:          map['sex'],
      langs:        map['langs'].cast<String>(),
      userpicUrls:  toStringStringMap(map['userpicUrls']),
      location:     Location.fromMap(map['location']),
      bio:          map['bio'] ?? '',
    );
  }

  static List<User> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => User.fromMap(map))
        .toList()
        .cast<User>();
  }
}
