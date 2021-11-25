import 'package:courseplease/models/filters/gallery_lesson.dart';
import 'package:courseplease/screens/filter/local_blocs/filter.dart';
import 'package:courseplease/widgets/language_list_editor.dart';
import 'package:rxdart/rxdart.dart';

class GalleryLessonFilterDialogCubit extends AbstractFilterScreenContentCubit<GalleryLessonFilter> {
  final _statesController = BehaviorSubject<GalleryLessonFilterDialogCubitState>();
  Stream<GalleryLessonFilterDialogCubitState> get states => _statesController.stream;
  late final GalleryLessonFilterDialogCubitState initialState;

  final _langsController = LanguageListEditorController();

  GalleryLessonFilterDialogCubit() {
    initialState = _createState();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  GalleryLessonFilterDialogCubitState _createState() {
    return GalleryLessonFilterDialogCubitState(
      canClear:             true, // TODO
      langsController:      _langsController,
    );
  }

  void setFilter(GalleryLessonFilter filter) {
    _langsController.setIds(filter.langs);

    _pushOutput();
  }

  GalleryLessonFilter getFilter() {
    return GalleryLessonFilter(
      langs: _langsController.getIds(),
    );
  }

  @override
  void clear() {
    _langsController.value = [];
    _pushOutput();
  }

  @override
  void dispose() {
    _statesController.close();
  }
}

class GalleryLessonFilterDialogCubitState {
  final bool canClear;
  final LanguageListEditorController langsController;

  GalleryLessonFilterDialogCubitState({
    required this.canClear,
    required this.langsController,
  });
}
