import 'package:courseplease/models/user.dart';
import 'package:courseplease/utils/utils.dart';
import 'location.dart';
import 'money.dart';
import 'product_variant_format.dart';
import 'rating.dart';
import 'teacher_subject.dart';

class Teacher extends User {
  final List<ProductVariantFormat> productVariantFormats;
  final Money minPrice;
  final Money maxPrice;
  final Rating rating;
  final List<TeacherSubject> subjects;
  final subjectIds = <int>[];

  Teacher({
    required int id,
    required String firstName,
    required String middleName,
    required String lastName,
    required String sex,
    required List<String> langs,
    required Map<String, String> userpicUrls,
    required Location location,
    required String bio,
    required this.productVariantFormats,
    required this.minPrice,
    required this.maxPrice,
    required this.rating,
    required this.subjects,
  }) : super(
    id:           id,
    firstName:    firstName,
    middleName:   middleName,
    lastName:     lastName,
    sex:          sex,
    langs:        langs,
    userpicUrls:  userpicUrls,
    location:     location,
    bio:          bio,
  )
  {
    for (final ts in subjects) {
      subjectIds.add(ts.subjectId);
    }
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    final productVariantFormats = map['productVariantFormats']
        .map((map) => ProductVariantFormat.fromMap(map))
        .toList()
        .cast<ProductVariantFormat>();

    final subjects = TeacherSubject.fromMaps(map['subjects'] ?? []);

    return Teacher(
      id:                     map['id'],
      firstName:              map['firstName'],
      middleName:             map['middleName'],
      lastName:               map['lastName'],
      sex:                    map['sex'],
      langs:                  map['langs'].cast<String>(),
      userpicUrls:            toStringStringMap(map['userpicUrls']),
      location:               Location.fromMap(map['location']),
      bio:                    map['bio'] ?? '',
      productVariantFormats:  productVariantFormats,
      minPrice:               Money.fromMapOrList(map['minPrice']),
      maxPrice:               Money.fromMapOrList(map['maxPrice']),
      rating:                 Rating.fromMap(map['rating']),
      subjects:               subjects,
    );
  }

  TeacherSubject? getTeacherSubjectById(int subjectId) {
    for (final ts in subjects) {
      if (ts.subjectId == subjectId) return ts;
    }
    return null;
  }
}
