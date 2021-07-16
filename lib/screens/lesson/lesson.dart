import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/models/filters/comment.dart';
import 'package:courseplease/models/reaction/enum/comment_catalog_intname.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/services/reload/lesson.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/builders/models/lesson.dart';
import 'package:courseplease/widgets/pad.dart';
import 'package:courseplease/widgets/reaction/comment_list_and_form.dart';
import 'package:courseplease/widgets/teacher_and_reactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart'; // https://github.com/sarbagyastha/youtube_player_flutter/issues/460#issuecomment-799992113
import '../../models/lesson.dart';

class LessonScreen extends StatefulWidget {
  static const routeName = '/lessonById';

  final int lessonId;
  final bool autoplay;

  LessonScreen({
    required this.lessonId,
    required this.autoplay,
  });

  @override
  _LessonScreenState createState() => _LessonScreenState();

  static Future<void> show({
    required BuildContext context,
    required int lessonId,
    required bool autoplay,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => LessonScreen(
          lessonId: lessonId,
          autoplay: autoplay,
        ),
      ),
    );
  }
}

class _LessonScreenState extends State<LessonScreen> {
  final _lessonByIdBloc = ModelByIdBloc<int, Lesson>(
      modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Lesson, LessonRepository>(),
  );

  YoutubePlayerController? _youtubePlayerController;
  final _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _lessonByIdBloc.setCurrentId(widget.lessonId);
  }

  @override
  Widget build(BuildContext context) {
    return LessonBuilderWidget(id: widget.lessonId, builder: _buildWithLesson);
  }

  Widget _buildWithLesson(BuildContext context, Lesson lesson) {
    _createYoutubePlayerControllerIfNot(lesson);

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
          teacherId: lesson.author.id,
          commentable: lesson,
          onCommentPressed: _commentFocusNode.requestFocus,
        ),
      ],
    );
  }

  void _onCommentCountChanged() {
    LessonReloadService().reload(widget.lessonId);
  }

  CommentFilter _getCommentFilter() {
    return CommentFilter(
      catalog: CommentCatalogIntNameEnum.lessons,
      objectId: widget.lessonId,
    );
  }

  @override
  void dispose() {
    _youtubePlayerController?.close();
    _lessonByIdBloc.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }
}
