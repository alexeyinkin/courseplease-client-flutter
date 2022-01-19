import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/models/lesson.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/repositories/gallery_lesson.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/screens/lesson/configurations.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:get_it/get_it.dart';

class LessonBloc extends AppPageStatefulBloc<LessonBlocState> {
  final int lessonId;
  Lesson? _lesson;
  ProductSubject? _productSubject;

  LessonBlocState get initialState => const LessonBlocState(lesson: null);

  final _modelByIdBloc = ModelByIdBloc<int, Lesson>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Lesson, GalleryLessonRepository>()
  );

  LessonBloc({
    required this.lessonId,
  }) {
    _modelByIdBloc.setCurrentId(lessonId);
    _modelByIdBloc.outState.listen(_onLessonChanged);
  }

  void _onLessonChanged(ModelByIdState<int, Lesson> state) {
    _lesson = state.object;
    _productSubject = GetIt.instance.get<ProductSubjectCacheBloc>().getObjectById(_lesson?.subjectId);
    emitState();
    emitConfigurationChangedIfAny();
  }

  @override
  LessonBlocState createState() {
    return LessonBlocState(
      lesson: _lesson,
    );
  }

  @override
  MyPageConfiguration? getConfiguration() {
    if (_productSubject == null) return null;
    return LessonConfiguration(
      lessonId: lessonId,
      subjectPath: _productSubject!.slashedPath,
    );
  }

  @override
  void dispose() {
    _modelByIdBloc.dispose();
    super.dispose();
  }
}

class LessonBlocState {
  final Lesson? lesson;

  const LessonBlocState({
    required this.lesson,
  });
}
