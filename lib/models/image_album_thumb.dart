class ImageAlbumThumb {
  final int id;
  final int purposeId;
  final String? lastPublishedImageThumbUrl;
  final int publishedImageCount;
  final DateTime? dateTimeLastPublish;

  ImageAlbumThumb({
    required this.id,
    required this.purposeId,
    required this.lastPublishedImageThumbUrl,
    required this.publishedImageCount,
    required this.dateTimeLastPublish,
  });

  factory ImageAlbumThumb.fromMap(Map<String, dynamic> map) {
    final dateTimeLastPublishString = map['dateTimeLastPublish'];

    return ImageAlbumThumb(
      id:                         map['id'],
      purposeId:                  map['purposeId'],
      lastPublishedImageThumbUrl: map['lastPublishedImageThumbUrl'],
      publishedImageCount:        map['publishedImageCount'],
      dateTimeLastPublish:        dateTimeLastPublishString == null ? null : DateTime.parse(dateTimeLastPublishString),
    );
  }

  static Map<int, ImageAlbumThumb?> fromMapByPurposeId(mapOrEmptyList) {
    if (mapOrEmptyList is List) return {};

    final maps = (mapOrEmptyList as Map).cast<String, Map<String, dynamic>>();
    final result = Map<int, ImageAlbumThumb?>();

    for (final purposeIdString in maps.keys) {
      final map = maps[purposeIdString];
      result[int.parse(purposeIdString)] = map == null
          ? null
          : ImageAlbumThumb.fromMap(map);
    }

    return result;
  }

  factory ImageAlbumThumb.from(ImageAlbumThumb obj) {
    return ImageAlbumThumb(
      id:                         obj.id,
      purposeId:                  obj.purposeId,
      lastPublishedImageThumbUrl: obj.lastPublishedImageThumbUrl,
      publishedImageCount:        obj.publishedImageCount,
      dateTimeLastPublish:        obj.dateTimeLastPublish,
    );
  }
}
