class ProductVariantFormat {
  final String title;

  ProductVariantFormat({
    required this.title,
  });

  factory ProductVariantFormat.fromMap(Map<String, dynamic> map) {
    return ProductVariantFormat(
      title:  map['title'],
    );
  }
}

class ProductVariantFormatIntNameEnum {
  static const consulting = 'consulting';
  static const consultingTeachersPlace = 'consulting/teachers-place';
  static const consultingStudentsPlace = 'consulting/students-place';
  static const consultingOnline = 'consulting/online';

  static const allForFilter = [
    consultingTeachersPlace,
    consultingStudentsPlace,
    consultingOnline,
  ];
}
