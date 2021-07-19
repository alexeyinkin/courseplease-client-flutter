class Likable {
  final int id;
  final int likeCount;
  final bool isLiked;
  final int loadTimestampMilliseconds;

  Likable({
    required this.id,
    required this.likeCount,
    required this.isLiked,
    required this.loadTimestampMilliseconds,
  });
}
