import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/reaction/enum/comment_catalog_intname.dart';
import 'package:courseplease/screens/image_pages/local_widgets/image_teacher_tile.dart';
import 'package:courseplease/services/reload/image.dart';
import 'package:courseplease/widgets/error/id.dart';
import 'package:courseplease/widgets/image_builder.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/reaction/comment_list_and_form.dart';
import 'package:courseplease/widgets/reaction/reaction_buttons.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/teacher_builder.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatefulWidget {
  final int imageId;
  final String imageHeroTag;

  ImageScreen({
    required this.imageId,
    required this.imageHeroTag,
  });

  static void show({
    required BuildContext context,
    required int imageId,
    required String imageHeroTag,
  }) async {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(
          imageId: imageId,
          imageHeroTag: imageHeroTag,
        ),
      ),
    );
  }

  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  final _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ImageBuilderWidget(
          id: widget.imageId,
          builder: _buildWithImage,
        ),
      ),
    );
  }

  Widget _buildWithImage(BuildContext context, ImageEntity image) {
    return Column(
      children: [
        Expanded(
          child: _getImageWidget(image),
        ),
        SmallPadding(),
        _buildUnderImage(image),
        HorizontalLine(),
        Expanded(
          flex: 2,
          child: CommentListAndForm(
            filter: _getCommentFilter(),
            commentFocusNode: _commentFocusNode,
            onCommentCountChanged: _onCommentCountChanged,
          ),
        ),
      ],
    );
  }

  void _onCommentCountChanged() {
    ImageReloadService().reload(widget.imageId);
    //ImageFireChangeService().fire(widget.imageId);
  }

  Widget _getImageWidget(ImageEntity image) {
    final urlTail = image.getLightboxUrl();
    if (urlTail == null) return IdErrorWidget(object: image);

    final url = 'https://courseplease.com' + urlTail;

    return Stack(
      children: [
        Container(width: double.infinity),
        Center(
          child: Hero(
            tag: widget.imageHeroTag,
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => SmallCircularProgressIndicator(),
              errorWidget: (context, url, error) => IdErrorWidget(object: image),
              fadeInDuration: Duration(),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: BackButton(),
        ),
      ],
    );
  }

  Widget _buildUnderImage(ImageEntity image) {
    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: TeacherBuilderWidget(
              id: image.authorId,
              builder: (context, teacher) => ImageTeacherTile(teacher: teacher),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: ReactionButtons(
              commentable: image,
              onCommentPressed: () => _commentFocusNode.requestFocus(),
            ),
          ),
        ],
      ),
    );
  }

  CommentFilter _getCommentFilter() {
    return CommentFilter(
      catalog: CommentCatalogIntNameEnum.images,
      objectId: widget.imageId,
    );
  }
}
