import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/screens/image/image.dart';
import 'package:courseplease/screens/image_pages/local_widgets/previous_image_overlay.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/error/id.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/filters/gallery_image.dart';
import '../../models/image.dart';
import 'local_widgets/close_image_overlay.dart';
import 'local_widgets/image_reaction_overlay.dart';
import 'local_widgets/image_teacher_overlay.dart';
import 'local_widgets/image_title_overlay.dart';
import 'local_widgets/next_image_overlay.dart';

typedef List<Widget> ImageOverlayBuilder({
  required BuildContext context,
  required ImageEntity image,
  required String imageHeroTag,
  required bool controlsVisible,
  VoidCallback? onPreviousPressed,
  VoidCallback? onNextPressed,
});

class ImagePagesScreen<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends StatefulWidget {
  final F filter;
  final int initialIndex;
  final ImageOverlayBuilder? imageOverlayBuilder;

  ImagePagesScreen({
    required this.filter,
    required this.initialIndex,
    this.imageOverlayBuilder,
  });

  @override
  ImagePagesScreenState<F, R> createState() => ImagePagesScreenState(
    filter: filter,
    index: initialIndex,
  );
}

class ImagePagesScreenState<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends State<ImagePagesScreen<F, R>> {
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();

  late final PageController _pageController;
  final F filter;
  int index;
  bool _controlsVisible = true;

  static const _transitionDuration = Duration(milliseconds: 300);
  static const _transitionCurve = Curves.ease;

  ImagePagesScreenState({
    required this.filter,
    required this.index,
  }) {
    _pageController = PageController(
      initialPage: index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final listBloc = _filteredModelListCache.getOrCreate<int, ImageEntity, F, R>(filter);

    return StreamBuilder<ModelListState<int, ImageEntity>>(
      stream: listBloc.outState,
      builder: (context, snapshot) {
        return _buildWithListState(
          context,
          snapshot.data ?? listBloc.initialState,
          listBloc,
        );
      },
    );
  }

  Widget _buildWithListState(
    BuildContext context,
    ModelListState<int, ImageEntity> listState,
    AbstractFilteredModelListBloc bloc,
  ) {
    final length = listState.objects.length;
    final totalLength = listState.hasMore ? null : length;

    // TODO: Handle error.

    return Material(
      type: MaterialType.canvas,
      color: AppStyle.lightboxBackgroundColor,
      child: SafeArea(
        child: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              PageView.builder(
                allowImplicitScrolling: true,
                controller: _pageController,
                itemCount: totalLength,
                itemBuilder: (context, index) {
                  if (index < length) {
                    return _buildPage(context, listState, index, totalLength);
                  }
                  bloc.loadMoreIfCan();
                  return SmallCircularProgressIndicator();
                }
              ),
              ..._getStaticControls(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getStaticControls() {
    final result = <Widget>[];

    result.add(
      CloseImageOverlay(visible: _controlsVisible),
    );

    return result;
  }

  Widget _buildPage(BuildContext context, ModelListState<int, ImageEntity> listState, int index, int? totalLength) {
    final image = listState.objects[index];

    final urlTail = image.getLightboxUrl();
    if (urlTail == null) return IdErrorWidget(object: image);

    final url = 'https://courseplease.com' + urlTail;

    return Dismissible(
      key: ValueKey('page-' + index.toString()),
      direction: DismissDirection.down,
      onDismissed: (direction) {
        Navigator.of(context).pop();
      },
      child: Stack(
        children: [
          Center(
            child: Hero(
              tag: _getHeroTag(image),
              child: CachedNetworkImage(
                imageUrl: url,
                placeholder: (context, url) => SmallCircularProgressIndicator(),
                errorWidget: (context, url, error) => IdErrorWidget(object: image),
                fadeInDuration: Duration(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ..._buildOverlays(context, image, index, totalLength),
        ],
      ),
    );
  }

  String _getHeroTag(ImageEntity image) {
    return 'image_' + widget.filter.toString() + '_' + image.id.toString();
  }

  List<Widget> _buildOverlays(BuildContext context, ImageEntity image, int index, int? totalLength) {
    if (widget.imageOverlayBuilder == null) return [];

    return widget.imageOverlayBuilder!(
      context: context,
      image: image,
      controlsVisible: _controlsVisible,
      imageHeroTag: _getHeroTag(image),
      onPreviousPressed: index == 0 ? null : () => _pageController.previousPage(duration: _transitionDuration, curve: _transitionCurve),
      onNextPressed: (index - 1) == totalLength ? null : () => _pageController.nextPage(duration: _transitionDuration, curve: _transitionCurve),
    );
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
  }
}

class ViewImagePagesScreenLauncher {
  static Future<void> show({
    required BuildContext context,
    required GalleryImageFilter filter,
    required int initialIndex,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePagesScreen<GalleryImageFilter, GalleryImageRepository>(
          filter: filter,
          initialIndex: initialIndex,
          imageOverlayBuilder: _buildOverlays,
        ),
      ),
    );
  }

  static List<Widget> _buildOverlays({
    required BuildContext context,
    required ImageEntity image,
    required String imageHeroTag,
    required bool controlsVisible,
    VoidCallback? onPreviousPressed,
    VoidCallback? onNextPressed,
    VoidCallback? onClosePressed,
  }) {
    final result = <Widget>[
      ImageTitleOverlay(image: image, visible: controlsVisible),
      ImageTeacherOverlay(teacherId: image.authorId, visible: controlsVisible),
      ImageReactionOverlay(
        image: image,
        visible: controlsVisible,
        onCommentPressed: (){
          ImageScreen.show(
            context: context,
            imageId: image.id,
            imageHeroTag: imageHeroTag,
          );
        },
      ),
    ];

    if (onPreviousPressed != null) {
      result.add(PreviousImageOverlay(visible: controlsVisible, onPressed: onPreviousPressed));
    }

    if (onNextPressed != null) {
      result.add(NextImageOverlay(visible: controlsVisible, onPressed: onNextPressed));
    }

    return result;
  }
}

class ImagePagesScreenLauncher {
  static Future<void> showWithTitles<F extends AbstractFilter, R extends AbstractImageRepository<F>>({
    required BuildContext context,
    required F filter,
    required int initialIndex,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePagesScreen<F, R>(
          filter: filter,
          initialIndex: initialIndex,
          imageOverlayBuilder: _buildOverlays,
        ),
      ),
    );
  }

  static List<Widget> _buildOverlays({
    required BuildContext context,
    required ImageEntity image,
    required String imageHeroTag,
    required bool controlsVisible,
    VoidCallback? onPreviousPressed,
    VoidCallback? onNextPressed,
  }) {
    final result = <Widget>[
      ImageTitleOverlay(image: image, visible: controlsVisible),
    ];

    if (onPreviousPressed != null) {
      result.add(PreviousImageOverlay(visible: controlsVisible, onPressed: onPreviousPressed));
    }

    if (onNextPressed != null) {
      result.add(NextImageOverlay(visible: controlsVisible, onPressed: onNextPressed));
    }

    return result;
  }
}
