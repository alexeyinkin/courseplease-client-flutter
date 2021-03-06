class Mapping {
  final String? classShortIntName;
  final DateTime? dateTimeSyncFromRemote;
  final String? contactUsername;
  final String? url;

  Mapping({
    this.classShortIntName,
    this.dateTimeSyncFromRemote,
    this.contactUsername,
    this.url,
  });

  factory Mapping.fromMap(Map<String, dynamic> map) {
    final syncFromRemote = map['dateTimeSyncFromRemote'];
    return Mapping(
      classShortIntName:      map['classShortIntName'],
      dateTimeSyncFromRemote: syncFromRemote == null ? null : DateTime.parse(syncFromRemote),
      contactUsername:        map['contactUsername'],
      url:                    map['url'],
    );
  }

  static List<Mapping> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => Mapping.fromMap(map))
        .toList()
        .cast<Mapping>();
  }
}
