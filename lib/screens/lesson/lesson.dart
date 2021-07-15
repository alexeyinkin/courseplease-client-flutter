import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/screens/image_pages/local_widgets/image_teacher_tile.dart'; // TODO: Don't use other screen's local widget.
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
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

  @override
  void initState() {
    super.initState();
    _lessonByIdBloc.setCurrentId(widget.lessonId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelByIdState<int, Lesson>>(
      stream: _lessonByIdBloc.outState,
      builder: (context, snapshot) => _buildWithLessonState(context, snapshot.data ?? _lessonByIdBloc.initialState),
    );
  }

  Widget _buildWithLessonState(BuildContext context, ModelByIdState<int, Lesson> lessonByIdState) {
    final lesson = lessonByIdState.object;

    return lesson == null
        ? _buildWithoutLesson(lessonByIdState)
        : _buildWithLesson(context, lesson);
  }

  // TODO: Extract to a separate widget
  Widget _buildWithoutLesson(ModelByIdState<int, Lesson> lessonByIdState) {
    switch (lessonByIdState.requestStatus) {
      case RequestStatus.notTried:
      case RequestStatus.loading:
        return SmallCircularProgressIndicator();
      default:
        return Center(child: Icon(Icons.error));
    }
  }

  Widget _buildWithLesson(BuildContext context, Lesson lesson) {
    _createYoutubePlayerControllerIfNot(lesson);

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: YoutubePlayerIFrame(
                controller: _youtubePlayerController,
                aspectRatio: 16 / 9,
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                lesson.title,
                style: AppStyle.pageTitle,
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: ImageTeacherTile(teacher: lesson.author),
            ),
            Container(
              child: Markdown(
                data: lesson.body,
                shrinkWrap: true,
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

  @override
  void dispose() {
    super.dispose();
    _youtubePlayerController?.close();
    _lessonByIdBloc.dispose();
  }
}
