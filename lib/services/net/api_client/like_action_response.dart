class LikeActionResponse {
  final bool isSuccess;

  LikeActionResponse({
    required this.isSuccess,
  });

  factory LikeActionResponse.fromMap(Map<String, dynamic> map) {
    return LikeActionResponse(
      isSuccess: map['isSuccess'],
    );
  }
}
