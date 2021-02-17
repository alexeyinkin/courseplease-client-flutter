import 'package:meta/meta.dart';

import 'interfaces.dart';
import 'mapping.dart';

// Flutter has an 'Image' widget. Naming is to avoid conflicts.
class ImageEntity implements WithId<int> {
  final int id;
  final String title;
  final Map<String, String> urls;
  final int authorId;
  final List<Mapping> mappings;

  static const lightboxFormat = '2000x2000';

  ImageEntity({
    @required this.id,
    @required this.title,
    @required this.urls,
    @required this.authorId,
    @required this.mappings,
  });

  factory ImageEntity.fromMap(Map<String, dynamic> map) {
    var urlsUncast = map['urls'];
    var urls = (urlsUncast is List)
        ? Map<String, String>()  // Empty PHP array converted to array instead of map.
        : urlsUncast.cast<String, String>();

    return ImageEntity(
      id: map['id'],
      title: map['title'],
      urls: urls,
      authorId: map['authorId'],
      mappings: Mapping.fromMaps(map['mappings'] ?? []),
    );
  }

  String getLightboxUrl() {
    return urls[lightboxFormat];
  }
}
