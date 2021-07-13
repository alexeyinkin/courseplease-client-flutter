import 'dart:io';
import 'dart:typed_data';

import 'package:courseplease/models/image.dart';
import 'package:courseplease/services/upload/image_scaler.dart';
import 'package:courseplease/models/upload/image_upload.dart';
import 'package:courseplease/models/upload/scale_options.dart';
import 'package:image_picker/image_picker.dart';

class CallbackImageUploader {
  Stream<ImageUpload> pickAndUploadImage(
    ScaleOptions scaleOptions,
    CallbackImageUploadOptions uploadOptions,
  ) async* {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final tempId = ImageUpload.getNextTempId();

    yield ImageUpload(
      tempId: tempId,
      localFile: file,
      status: ImageUploadStatus.compressing,
      urls: {},
    );

    final inputBytes = await pickedFile.readAsBytes();
    final scaledBytes = await ImageScaler(options: scaleOptions).scaleIfNeed(inputBytes);

    yield ImageUpload(
      tempId: tempId,
      localFile: file,
      status: ImageUploadStatus.uploading,
      urls: {},
    );

    final image = await uploadOptions.callback(scaledBytes);

    yield ImageUpload(
      tempId: tempId,
      localFile: file,
      status: ImageUploadStatus.complete,
      urls: image.urls,
    );
  }
}

class CallbackImageUploadOptions {
  final Future<ImageEntity> Function(Uint8List bytes) callback;

  CallbackImageUploadOptions({
    required this.callback,
  });
}
