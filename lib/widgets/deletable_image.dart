import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/server_image.dart';
import 'package:courseplease/models/upload/image_upload.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class DeletableImageWidget extends StatelessWidget {
  final ServerImage serverImage;
  final double size;
  final VoidCallback? onDeletePressed;
  final Widget Function(BuildContext context, Widget child) frameBuilder;

  DeletableImageWidget({
    required this.serverImage,
    required this.size,
    this.onDeletePressed,
    required this.frameBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          _getImageLayer(context),
          _getProgressLayer(),
          _getDeleteButtonLayer(),
        ],
      ),
    );
  }

  Widget _getImageLayer(BuildContext context) {
    if (serverImage is ImageUpload) {
      return _getLocalImageLayer(context, serverImage as ImageUpload);
    }
    if (serverImage is ImageEntity) {
      return _getUploadedImageLayer(context, serverImage as ImageEntity);
    }
    throw Exception('Unknown serverImage type: ' + serverImage.runtimeType.toString());
  }

  Widget _getLocalImageLayer(BuildContext context, ImageUpload imageUpload) {
    return Positioned.fill(
      child: Opacity(
        opacity: _isComplete(imageUpload) ? 1 : .4,
        child: frameBuilder(
          context,
          Image.file(
            imageUpload.localFile,
          ),
        ),
      ),
    );
  }

  bool _isComplete(ImageUpload imageUpload) {
    return imageUpload.status == ImageUploadStatus.complete;
  }

  Widget _getUploadedImageLayer(BuildContext context, ImageEntity imageEntity) {
    return Positioned.fill(
      child: frameBuilder(
        context,
        Image.network(
          imageEntity.urls.values.first,
        ),
      ),
    );
  }

  Widget _getProgressLayer() {
    if (!(serverImage is ImageUpload)) return Container();
    if (!_isInProgress(serverImage as ImageUpload)) return Container();

    return Center(
      child: SmallCircularProgressIndicator(),
    );
  }

  bool _isInProgress(ImageUpload imageUpload) {
    switch (imageUpload.status) {
      case ImageUploadStatus.compressing:
      case ImageUploadStatus.uploading:
        return true;
      default:
        return false;
    }
  }

  Widget _getDeleteButtonLayer() {
    if (onDeletePressed == null) return Container();

    return Positioned(
      top: -10,
      right: -10,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(20, 20),
        ),
        onPressed: onDeletePressed,
        child: Icon(
          Icons.cancel,
        ),
      )
    );
  }
}
