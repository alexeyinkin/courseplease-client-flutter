import 'package:meta/meta.dart';

import 'interfaces.dart';

class Photo implements WithId<int> {
  final int id;
  final String title;
  final Map<String, String> urls;
  final int authorId;

  static const lightboxFormat = '2000x2000';

  Photo({
    @required this.id,
    @required this.title,
    @required this.urls,
    @required this.authorId,
  });

  factory Photo.fromMap(Map<String, dynamic> map) {
    var urlsUncast = map['urls'];
    var urls = (urlsUncast is List)
        ? Map<String, String>()  // Empty PHP array converted to array instead of map.
        : urlsUncast.cast<String, String>();

    return Photo(
      id: map['id'],
      title: map['title'],
      urls: urls,
      authorId: map['authorId'],
    );
  }

  String getLightboxUrl() {
    return urls[lightboxFormat];
  }
}
