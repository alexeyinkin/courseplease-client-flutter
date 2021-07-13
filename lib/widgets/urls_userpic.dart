import 'package:flutter/material.dart';

class UrlsUserpicWidget extends StatelessWidget {
  final Map<String, String> imageUrls;
  final double size;

  UrlsUserpicWidget({
    required this.imageUrls,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final userpicUrlTail = imageUrls['300x300'] ?? null;

    if (userpicUrlTail == null) {
      return Icon(Icons.person, size: size);
    }

    final userpicUrl = 'https://courseplease.com' + userpicUrlTail;

    return CircleAvatar(
      radius: size / 2,
      backgroundImage: NetworkImage(userpicUrl),
    );
  }
}
