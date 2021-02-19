import 'package:meta/meta.dart';

import 'interfaces.dart';
import 'mapping.dart';

// Flutter has an 'Image' widget. Naming is to avoid conflicts.
class ImageEntity implements WithId<int> {
  final int id;
  final String title;
  final Map<String, String> urls;
  final int authorId;
  final ImageStatus status;
  final List<ImageAlbumLink> albums;
  final List<Mapping> mappings;

  static const lightboxFormat = '2000x2000';

  ImageEntity({
    @required this.id,
    @required this.title,
    @required this.urls,
    @required this.authorId,
    @required this.status,
    @required this.albums,
    @required this.mappings,
  });

  factory ImageEntity.fromMap(Map<String, dynamic> map) {
    final albums = ImageAlbumLink.fromMaps(map['albums']);
    final urlsUncast = map['urls'];
    final urls = (urlsUncast is List)
        ? Map<String, String>()  // Empty PHP array converted to array instead of map.
        : urlsUncast.cast<String, String>();

    return ImageEntity(
      id: map['id'],
      title: map['title'],
      urls: urls,
      authorId: map['authorId'],
      status: ImageEntity.getStatus(albums),
      albums: albums,
      mappings: Mapping.fromMaps(map['mappings'] ?? []),
    );
  }

  String getLightboxUrl() {
    return urls[lightboxFormat];
  }

  static ImageStatus getStatus(List<ImageAlbumLink> links) {
    if (links.isEmpty) return ImageStatus.orphan;

    ImageAlbumLink unsortedAlbum = null;
    for (final link in links) {
      if (link.purposeId == ImageAlbumPurpose.unsorted) {
        unsortedAlbum = link;
        break;
      }
    }
    if (unsortedAlbum != null && links.length > 1) {
      return ImageStatus.inconsistent; // TODO: Log
    }

    ImageAlbumLink undeletedAlbum = null;
    for (final link in links) {
      if (link.dateTimeDelete == null) {
        undeletedAlbum = link;
        break;
      }
    }
    if (undeletedAlbum == null) return ImageStatus.trash;
    if (unsortedAlbum != null) return ImageStatus.unsorted;

    ImageAlbumLink nonRejectedAlbum = null;
    for (final link in links) {
      if (link.status != ImageAlbumLinkStatus.rejected) {
        nonRejectedAlbum = link;
        break;
      }
    }
    if (nonRejectedAlbum == null) return ImageStatus.rejected;

    ImageAlbumLink publishedAlbum = null;
    for (final link in links) {
      if (link.status == ImageAlbumLinkStatus.published) {
        publishedAlbum = link;
        break;
      }
    }
    if (publishedAlbum != null) return ImageStatus.published;

    ImageAlbumLink nonReviewAlbum = null;
    for (final link in links) {
      if (link.status != ImageAlbumLinkStatus.review) {
        nonReviewAlbum = link;
        break;
      }
    }
    if (nonReviewAlbum != null) return ImageStatus.inconsistent; // TODO: Log

    return ImageStatus.review;
  }
}

class ImageAlbumLink {
  final int albumId;
  final int purposeId;
  final int status;
  final DateTime dateTimeDelete; // Nullable
  final List<int> subjectIds;

  ImageAlbumLink({
    @required this.albumId,
    @required this.purposeId,
    @required this.status,
    @required this.dateTimeDelete,
    @required this.subjectIds,
  });

  factory ImageAlbumLink.fromMap(Map<String, dynamic> map) {
    final dateTimeDeleteString = map['dateTimeDelete'];

    return ImageAlbumLink(
      albumId:        map['albumId'],
      purposeId:      map['purposeId'],
      status:         map['status'],
      dateTimeDelete: dateTimeDeleteString == null ? null : DateTime.parse(dateTimeDeleteString),
      subjectIds:     map['subjectIds'].cast<int>(),
    );
  }

  static List<ImageAlbumLink> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => ImageAlbumLink.fromMap(map))
        .toList()
        .cast<ImageAlbumLink>();
  }
}

class ImageAlbumLinkStatus {
  static const review = 1;
  static const rejected = 3;
  static const published = 100;
}

class ImageAlbumPurpose {
  static const portfolio = 4;
  static const customersPortfolio = 5;
  static const unsorted = 6;
  static const backstage = 8;
}

enum ImageStatus {
  orphan,
  inconsistent,
  published,
  unsorted,
  review,
  rejected,
  trash,
}
