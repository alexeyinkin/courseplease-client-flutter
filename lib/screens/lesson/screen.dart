import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/models/reaction/enum/comment_catalog_intname.dart';
import 'package:courseplease/models/reaction/enum/like_catalog_intname.dart';
import 'package:courseplease/services/reload/lesson.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/reaction/comment_list_and_form.dart';
import 'package:courseplease/widgets/teacher_and_reactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart'; // https://github.com/sarbagyastha/youtube_player_flutter/issues/460#issuecomment-799992113
import '../../models/lesson.dart';

import 'bloc.dart';

class LessonScreen extends StatefulWidget {
  final LessonBloc bloc;
  final bool autoplay;

  LessonScreen({
    required this.bloc,
    required this.autoplay,
  });

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  YoutubePlayerController? _youtubePlayerController;
  final _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.bloc.states.listen(_onLessonChanged);
  }

  void _onLessonChanged(LessonBlocState state) {
    final lesson = state.lesson;
    if (lesson == null) return;

    _createYoutubePlayerControllerIfNot(lesson);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LessonBlocState>(
      stream: widget.bloc.states,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? widget.bloc.initialState),
    );
  }

  Widget _buildWithState(LessonBlocState state) {
    final lesson = state.lesson;
    if (lesson == null) return Container();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: YoutubePlayerIFrame(
                controller: _youtubePlayerController,
                aspectRatio: 16 / 9,
              ),
            ),
            _buildUnderVideo(lesson),
            HorizontalLine(),
            Container(
              child: Markdown(
                data: lesson.body,
                shrinkWrap: true,
              ),
            ),
            HorizontalLine(),
            Container(
              height: 400,
              child: CommentListAndForm(
                filter: _getCommentFilter(),
                commentFocusNode: _commentFocusNode,
                onCommentCountChanged: _onCommentCountChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createYoutubePlayerControllerIfNot(Lesson lesson) {
    if (_youtubePlayerController != null) return;

    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: lesson.externalId,
      params: YoutubePlayerParams(
        autoPlay: widget.autoplay,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  Widget _buildUnderVideo(Lesson lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
          child: Text(
            lesson.title,
            style: AppStyle.h3,
          ),
        ),
        TeacherAndReactionsWidget(
          teacherId: lesson.authorId,
          commentable: lesson,
          onCommentPressed: _commentFocusNode.requestFocus,
          likable: lesson,
          catalog: LikeCatalogIntNameEnum.lessons,
          reloadCallback: () => LessonReloadService().reload(lesson.id),
          isMy: lesson.authorId == getCurrentUserId(),
        ),
      ],
    );
  }

  void _onCommentCountChanged() {
    LessonReloadService().reload(widget.bloc.lessonId);
  }

  CommentFilter _getCommentFilter() {
    return CommentFilter(
      catalog: CommentCatalogIntNameEnum.lessons,
      objectId: widget.bloc.lessonId,
    );
  }

  @override
  void dispose() {
    _youtubePlayerController?.close();
    _commentFocusNode.dispose();
    super.dispose();
  }
}
