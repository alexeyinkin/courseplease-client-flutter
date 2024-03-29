import 'dart:async';

import 'package:courseplease/blocs/pages.dart';
import 'package:courseplease/blocs/product_subject_cache.dart';
import 'package:courseplease/blocs/page.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/filters/gallery_image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/product_subject.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/router/page_configuration.dart';
import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/screens/image/page.dart';
import 'package:get_it/get_it.dart';

abstract class ImagePagesBloc<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends AppPageStatefulBloc<ImagePagesBlocState> {
  final PagesBloc<int, ImageEntity, F, R> pagesBloc;

  late final StreamSubscription _listBlocSubscription;

  bool _controlsVisible = true;

  final ImagePagesBlocState initialState;

  ImagePagesBloc({
    required F filter,
    required int initialIndex,
    required int initialId,
  }) :
      initialState = ImagePagesBlocState(
        controlsVisible: true,
      ),
      pagesBloc = PagesBloc<int, ImageEntity, F, R>(
        filter: filter,
        initialIndex: initialIndex,
        initialId: initialId,
      )
  {
    pagesBloc.pageController.addListener(_onPageChanged);
    _listBlocSubscription = pagesBloc.listBloc.outState.listen((_) => _onListChanged());
  }

  void _onPageChanged() {
    emitConfigurationChangedIfAny();
  }

  void _onListChanged() {
    emitConfigurationChangedIfAny();
  }

  void toggleControls() {
    _controlsVisible = !_controlsVisible;
    emitState();
  }

  @override
  ImagePagesBlocState createState() {
    return ImagePagesBlocState(
      controlsVisible: _controlsVisible,
    );
  }

  @override
  void dispose() {
    pagesBloc.dispose();
    _listBlocSubscription.cancel();
    super.dispose();
  }
}

class ImagePagesBlocState {
  final bool controlsVisible;

  const ImagePagesBlocState({
    required this.controlsVisible,
  });
}

class ImagePagesGalleryBloc extends ImagePagesBloc<GalleryImageFilter, GalleryImageRepository> {
  final ProductSubject? _productSubject;

  ImagePagesGalleryBloc({
    required GalleryImageFilter filter,
    required int initialIndex,
    required int initialId,
  }) :
      _productSubject = GetIt.instance.get<ProductSubjectCacheBloc>().getObjectById(filter.subjectId),
      super(
        filter: filter,
        initialIndex: initialIndex,
        initialId: initialId,
      )
  ;

  @override
  MyPageConfiguration? getConfiguration() {
    // TODO: Create configuration for pages to have URLs.
    return null;
  }

  void onCommentPressed() {
    GetIt.instance.get<AppState>().pushPage(
      ImagePage(
        imageId: pagesBloc.getCurrentId(),
        subjectPath: _requireProductSubject().slashedPath,
      ),
    );
  }

  ProductSubject _requireProductSubject() {
    return _productSubject ?? (throw Exception('This requires ProductSubject'));
  }
}

class ImagePagesTitlesBloc<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends ImagePagesBloc<F, R> {
  ImagePagesTitlesBloc({
    required F filter,
    required int initialIndex,
    required int initialId,
  }) : super(
    filter: filter,
    initialIndex: initialIndex,
    initialId: initialId,
  );

  @override
  MyPageConfiguration? getConfiguration() => null;
}
