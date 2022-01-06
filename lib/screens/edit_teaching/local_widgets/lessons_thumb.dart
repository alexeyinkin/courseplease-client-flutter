import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/album_thumb.dart';
import 'package:courseplease/models/filters/my_lesson.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/repositories/my_lesson.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/my_lesson_list/page.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'album_thumb.dart';

class LessonsThumbWidget extends StatelessWidget {
  final ProductSubject productSubject;

  LessonsThumbWidget({
    required this.productSubject,
  });

  @override
  Widget build(BuildContext context) {
    final filter = MyLessonFilter(
      subjectIds: [productSubject.id],
    );

    final cache = GetIt.instance.get<FilteredModelListCache>();
    final list = cache.getOrCreateNetworkList<int, Lesson, MyLessonFilter, MyLessonRepository>(filter);

    list.loadInitialIfNot();

    return StreamBuilder<ModelListState<int, Lesson>>(
      stream: list.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? list.initialState),
    );
  }

  Widget _buildWithState(ModelListState<int, Lesson> state) {
    return AlbumThumbWidget(
      titleText: tr('LessonsThumbWidget.title'),
      thumb: _getAlbumThumb(state),
      productSubject: productSubject,
      onTap: _onTap,
      emptyIconData: Icons.ondemand_video_outlined,
    );
  }

  AlbumThumb? _getAlbumThumb(ModelListState<int, Lesson> state) {
    if (state.objects.isEmpty) return null;

    final recentLesson = state.objects[0];

    return AlbumThumb(
      lastPublishedImageThumbUrl: recentLesson.coverUrls.values.first,
      publishedImageCount: 0, // TODO: Total count.
      dateTimeLastPublish: recentLesson.dateTimeInsert,
    );
  }

  void _onTap() {
    GetIt.instance.get<AppState>().pushPage(
      MyLessonListPage(
        filter: MyLessonFilter(
          subjectIds: [productSubject.id],
        ),
      ),
    );
  }
}
