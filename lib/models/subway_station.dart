class SubwayStation {
  final int id;
  final String title;
  final int color;

  SubwayStation({
    required this.id,
    required this.title,
    required this.color,
  });

  factory SubwayStation.fromMap(Map<String, dynamic> map) {
    return SubwayStation(
      id:     map['id'],
      title:  map['title'],
      color:  map['color'],
    );
  }
}
