import 'package:courseplease/blocs/filterable.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:rxdart/rxdart.dart';

class ImagesTabCubit extends FilterableCubit<GalleryImageFilter> {
  final _statesController = BehaviorSubject<ImagesTabCubitState>();
  Stream<ImagesTabCubitState> get states => _statesController.stream;
  late final ImagesTabCubitState initialState;

  GalleryImageFilter _filter;

  ImagesTabCubit({
    required GalleryImageFilter initialFilter,
  }) :
      _filter = initialFilter
  {
    initialState = _createState();
  }

  void setFilter(GalleryImageFilter filter) {
    _filter = filter;
    _pushOutput();
  }

  void _pushOutput() {
    _statesController.sink.add(_createState());
  }

  ImagesTabCubitState _createState() {
    return ImagesTabCubitState(
      filter: _filter,
    );
  }

  @override
  void dispose() {
    _statesController.close();
  }
}

class ImagesTabCubitState extends FilterableCubitState<GalleryImageFilter>{
  final GalleryImageFilter filter;

  ImagesTabCubitState({
    required this.filter,
  });
}
