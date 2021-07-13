import 'dart:typed_data';

import 'package:courseplease/models/upload/scale_options.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';

class ImageScaler {
  final ScaleOptions options;

  ImageScaler({
    required this.options,
  });

  Future<Uint8List> scaleIfNeed(Uint8List inputBytes) async {
    if (inputBytes.lengthInBytes < options.maxLength) {
      return inputBytes;
    }

    final message = _ScaleMessage(inputBytes: inputBytes, options: options);
    return compute(_scaleToJpeg, message);
  }

  static Future<Uint8List> _scaleToJpeg(_ScaleMessage message) async {
    final image = decodeImage(message.inputBytes);

    if (image == null) {
      throw Exception('Cannot decode image');
    }

    final thumbnail = copyResize(
      image,
      width: message.options.width,
      height: message.options.height,
    );

    return Uint8List.fromList(encodeJpg(thumbnail));
  }
}

class _ScaleMessage {
  final Uint8List inputBytes;
  final ScaleOptions options;

  _ScaleMessage({
    required this.inputBytes,
    required this.options,
  });
}
