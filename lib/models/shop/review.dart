class Review {
  final double rating;
  final String text;
  final DateTime dateTimeInsert;

  Review({
    required this.rating,
    required this.text,
    required this.dateTimeInsert,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      rating: map['rating'].toDouble(),
      text: map['text'],
      dateTimeInsert: DateTime.parse(map['dateTimeInsert']),
    );
  }

  static Review? fromMapOrNull(Map<String, dynamic>? map) {
    return (map == null)
        ? null
        : Review.fromMap(map);
  }
}
