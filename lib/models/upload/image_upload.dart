import 'dart:io';

import '../server_image.dart';

class ImageUpload extends ServerImage {
  final String tempId;
  final File localFile;
  final ImageUploadStatus status;
  final Map<String, String> urls;

  static int _nextTempId = 0;

  ImageUpload({
    required this.tempId,
    required this.localFile,
    required this.status,
    required this.urls,
  });

  static String getNextTempId() {
    return 'upload_' + (_nextTempId++).toString();
  }

  bool isComplete() {
    return status == ImageUploadStatus.complete;
  }
}

enum ImageUploadStatus {
  compressing,
  uploading,
  complete,
  failed,
}
