import 'package:courseplease/utils/utils.dart';
import 'package:meta/meta.dart';
import 'interfaces.dart';
import 'location.dart';
import 'money.dart';
import 'product_variant_format.dart';
import 'rating.dart';
import 'teacher_subject.dart';

class Teacher implements WithId<int> {
  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final Map<String, String> userpicUrls;
  final List<ProductVariantFormat> productVariantFormats;
  final Money minPrice;
  final Money maxPrice;
  final Location location;
  final Rating rating;
  final List<TeacherSubject> categories;
  List<int> subjectIds;
  final String bio;

  Teacher({
    @required this.id,
    @required this.firstName,
    @required this.middleName,
    @required this.lastName,
    @required this.userpicUrls,
    @required this.productVariantFormats,
    @required this.minPrice,
    @required this.maxPrice,
    @required this.location,
    @required this.rating,
    @required this.categories,
    @required this.bio,
  }) {
    subjectIds = <int>[];
    for (final teacherCategory in categories) {
      subjectIds.add(teacherCategory.subjectId);
    }
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    var productVariantFormats = map['productVariantFormats']
        .map((map) => ProductVariantFormat.fromMap(map))
        .toList()
        .cast<ProductVariantFormat>();

    var categories = (map['categories'] ?? [])
        .map((map) => TeacherSubject.fromMap(map))
        .toList()
        .cast<TeacherSubject>();

    return Teacher(
      id:                     map['id'],
      firstName:              map['firstName'],
      middleName:             map['middleName'],
      lastName:               map['lastName'],
      userpicUrls:            toStringStringMap(map['userpicUrls']),
      productVariantFormats:  productVariantFormats,
      minPrice:               Money.fromMapOrList(map['minPrice']),
      maxPrice:               Money.fromMapOrList(map['maxPrice']),
      location:               Location.fromMap(map['location']),
      rating:                 Rating.fromMap(map['rating']),
      categories:             categories,
      bio:                    map['bio'] ?? '',
    );
  }
}
