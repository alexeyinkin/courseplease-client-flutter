import 'package:courseplease/models/image_album_thumb.dart';
import 'package:meta/meta.dart';
import 'product_variant_format_with_price.dart';

class TeacherSubject {
  final int subjectId;
  bool enabled;
  final String body;
  final Map<int, ImageAlbumThumb> imageAlbumThumbs;
  final List<ProductVariantFormatWithPrice> productVariantFormats;

  TeacherSubject({
    @required this.subjectId,
    @required this.enabled,
    @required this.body,
    @required this.imageAlbumThumbs,
    @required this.productVariantFormats,
  });

  factory TeacherSubject.fromMap(Map<String, dynamic> map) {
    var productVariantFormats = map['productVariantFormats']
        .map((map) => ProductVariantFormatWithPrice.fromMap(map))
        .toList()
        .cast<ProductVariantFormatWithPrice>();

    return TeacherSubject(
      subjectId:              map['subjectId'],
      enabled:                map['enabled'],
      body:                   map['body'],
      imageAlbumThumbs:       ImageAlbumThumb.fromMapByPurposeId(map['imageAlbumThumbs']),
      productVariantFormats:  productVariantFormats,
    );
  }

  static List<TeacherSubject> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => TeacherSubject.fromMap(map))
        .toList()
        .cast<TeacherSubject>();
  }

  factory TeacherSubject.from(TeacherSubject obj) {
    return TeacherSubject(
      subjectId:              obj.subjectId,
      enabled:                obj.enabled,
      body:                   obj.body,
      imageAlbumThumbs:       _cloneImageAlbumThumbs(obj.imageAlbumThumbs),
      productVariantFormats:  _cloneProductVariantFormats(obj.productVariantFormats),
    );
  }

  static Map<int, ImageAlbumThumb> _cloneImageAlbumThumbs(Map<int, ImageAlbumThumb> imageAlbumThumbs) {
    final result = Map<int, ImageAlbumThumb>();
    for (final purposeId in imageAlbumThumbs.keys) {
      result[purposeId] = ImageAlbumThumb.from(imageAlbumThumbs[purposeId]);
    }
    return result;
  }

  static List<ProductVariantFormatWithPrice> _cloneProductVariantFormats(List<ProductVariantFormatWithPrice> productVariantFormats) {
    final result = <ProductVariantFormatWithPrice>[];
    for (final format in productVariantFormats) {
      result.add(ProductVariantFormatWithPrice.from(format));
    }
    return result;
  }

  static List<int> getSubjectIds(List<TeacherSubject> subjects) {
    final ids = <int>[];
    for (final subject in subjects) {
      ids.add(subject.subjectId);
    }
    return ids;
  }
}
