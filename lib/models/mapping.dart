class Mapping {
  // Everything is Nullable.
  final String classShortIntName;
  final DateTime dateTimeSyncFromRemote;

  Mapping({
    this.classShortIntName,
    this.dateTimeSyncFromRemote,
  });

  factory Mapping.fromMap(Map<String, dynamic> map) {
    final syncFromRemote = map['dateTimeSyncFromRemote'];
    return Mapping(
      classShortIntName: map['classShortIntName'],
      dateTimeSyncFromRemote: syncFromRemote == null ? null : DateTime.parse(syncFromRemote),
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
