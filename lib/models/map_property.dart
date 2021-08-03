class MapProperty {
  final String intName;
  final String type;
  final String title;

  MapProperty({
    required this.intName,
    required this.type,
    required this.title,
  });

  factory MapProperty.fromMap(Map<String, dynamic> map) {
    return MapProperty(
      intName:  map['intName'],
      type:     map['type'],
      title:    map['title'],
    );
  }

  static List<MapProperty> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => MapProperty.fromMap(map))
        .toList()
        .cast<MapProperty>();
  }
}
