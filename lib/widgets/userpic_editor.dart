import 'package:courseplease/blocs/upload/single_image_upload.dart';
import 'package:courseplease/blocs/upload/userpic_editor_widget.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/widgets/rounded_clip_frame.dart';
import 'package:courseplease/widgets/urls_userpic.dart';
import 'package:flutter/material.dart';

import 'deletable_image.dart';

class UserpicEditorWidget extends StatefulWidget {
  final User user;
  final double size;

  UserpicEditorWidget({
    required this.user,
    required this.size,
  });

  @override
  _UserpicEditorWidgetState createState() => _UserpicEditorWidgetState();
}

class _UserpicEditorWidgetState extends State<UserpicEditorWidget> {
  final _cubit = UserpicEditorWidgetCubit();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SingleImageUploadCubitState>(
      stream: _cubit.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _cubit.initialState),
    );
  }

  Widget _buildWithState(SingleImageUploadCubitState state) {
    return Stack(
      children: [
        _getImageLayer(state),
        _getUploadButton(),
      ],
    );
  }

  Widget _getImageLayer(SingleImageUploadCubitState state) {
    if (state.serverImage != null) {
      return DeletableImageWidget(
        serverImage: state.serverImage!,
        size: widget.size,
        frameBuilder: (context, child) => RoundedClipFrameWidget(child: child, borderRadius: 500),
      );
    }

    return UrlsUserpicWidget(
      imageUrls: widget.user.userpicUrls,
      size: widget.size,
    );
  }

  Widget _getUploadButton() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
        ),
        child: Icon(Icons.edit),
        onPressed: _cubit.pickAndUpload,
      ),
    );
  }
}
