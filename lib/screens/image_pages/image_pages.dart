import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/screens/image/image.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/widgets/error/id.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/filters/image.dart';
import '../../models/image.dart';
import 'local_widgets/image_reaction_overlay.dart';
import 'local_widgets/image_teacher_overlay.dart';
import 'local_widgets/image_title_overlay.dart';

typedef List<Widget> ImageOverlayBuilder(BuildContext context, ImageEntity entity, bool controlsVisible);

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

    // TODO: Handle error.

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: GestureDetector(
          onTap: _toggleControls,
          child: PageView.builder(
            allowImplicitScrolling: true,
            controller: _pageController,
            itemCount: listState.hasMore ? null : length,
            itemBuilder: (context, index) {
              if (index < length) {
                return _buildPage(context, listState, index);
              }
              bloc.loadMoreIfCan();
              return SmallCircularProgressIndicator();
            }
          ),
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, ModelListState<int, ImageEntity> listState, int index) {
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
          ..._buildOverlays(context, image),
        ],
      ),
    );
  }

  String _getHeroTag(ImageEntity image) {
    return 'image_' + widget.filter.toString() + '_' + image.id.toString();
  }

  List<Widget> _buildOverlays(BuildContext context, ImageEntity image) {
    if (widget.imageOverlayBuilder == null) return [];
    return widget.imageOverlayBuilder!(context, image, _controlsVisible);
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
    required ViewImageFilter filter,
    required int initialIndex,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePagesScreen<ViewImageFilter, GalleryImageRepository>(
          filter: filter,
          initialIndex: initialIndex,
          imageOverlayBuilder: (context, image, visible) => [
            ImageTitleOverlay(image: image, visible: visible),
            ImageTeacherOverlay(teacherId: image.authorId, visible: visible),
            ImageReactionOverlay(
              image: image,
              visible: visible,
              onCommentPressed: (){
                ImageScreen.show(
                  context: context,
                  imageId: image.id,
                  imageHeroTag: 'image_' + filter.toString() + '_' + image.id.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
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
          imageOverlayBuilder: (context, image, visible) => [
            ImageTitleOverlay(image: image, visible: visible),
          ],
        ),
      ),
    );
  }
}
