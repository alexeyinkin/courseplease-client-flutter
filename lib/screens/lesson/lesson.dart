import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/screens/image/image.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../models/lesson.dart';

class LessonScreen extends StatefulWidget {
  static const routeName = '/lessonById';

  @override
  State<LessonScreen> createState() {
    return _LessonScreenState();
  }
}

class _LessonScreenState extends State<LessonScreen> {
  final _lessonByIdBloc = ModelByIdBloc<int, Lesson>(
      modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Lesson, LessonRepository>(),
  );

  int _lessonId;
  bool _autoplay;
  YoutubePlayerController _youtubePlayerController;

  @override
  Widget build(BuildContext context) {
    _startLoadingIfNot(context);

    return StreamBuilder(
      stream: _lessonByIdBloc.outState,
      initialData: _lessonByIdBloc.initialState,
      builder: (context, snapshot) => _buildWithLessonState(context, snapshot.data),
    );
  }

  Widget _buildWithLessonState(BuildContext context, ModelByIdState<int, Lesson> lessonByIdState) {
    final lesson = lessonByIdState.object;

    return lesson == null
        ? _buildWithoutLesson(context, lessonByIdState)
        : _buildWithLesson(context, lesson);
  }

  // TODO: Extract to a separate widget
  Widget _buildWithoutLesson(BuildContext, ModelByIdState<int, Lesson> lessonByIdState) {
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

  void _startLoadingIfNot(BuildContext context) {
    if (_lessonId == null) {
      final arguments = ModalRoute.of(context).settings.arguments as LessonScreenArguments;
      _lessonId = arguments.id;
      _autoplay = arguments.autoplay;
      _loadLesson();
    }
  }

  void _loadLesson() async {
    _lessonByIdBloc.setCurrentId(_lessonId);
  }

  void _createYoutubePlayerControllerIfNot(Lesson lesson) {
    if (_youtubePlayerController != null) return;

    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: lesson.externalId,
      params: YoutubePlayerParams(
        autoPlay: _autoplay,
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _lessonByIdBloc.dispose();
  }
}

class LessonScreenArguments {
  final int id;
  final bool autoplay;
  LessonScreenArguments({@required this.id, @required this.autoplay});
}
