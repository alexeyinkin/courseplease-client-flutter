class Rating {
  final double rating;
  final int voteCount;

  Rating({
    required this.rating,
    required this.voteCount,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      rating:     map['rating'].toDouble(),
      voteCount:  map['voteCount'],
    );
  }
}
