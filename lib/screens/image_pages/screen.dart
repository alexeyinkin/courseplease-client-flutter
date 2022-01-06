import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/pages.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/screens/image_pages/local_widgets/image_overlays.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/error/id.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import '../../models/image.dart';
import 'local_widgets/close_image_overlay.dart';

import 'bloc.dart';

class ImagePagesScreen<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends StatelessWidget {
  final ImagePagesBloc<F, R> bloc;
  final Widget Function(PagesBlocItem<ImageEntity>)? imageOverlayBuilder;

  ImagePagesScreen({
    required this.bloc,
    this.imageOverlayBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder2<ImagePagesBlocState, ModelListState<int, ImageEntity>>(
      streams: Tuple2(bloc.states, bloc.pagesBloc.listBloc.outState),
      builder: (context, snapshots) {
        return _buildWithStates(
          context,
          snapshots.item1.data ?? bloc.initialState,
          snapshots.item2.data ?? bloc.pagesBloc.listBloc.initialState,
        );
      },
    );
  }

  Widget _buildWithStates(
    BuildContext context,
    ImagePagesBlocState blocState,
    ModelListState<int, ImageEntity> listState,
  ) {
    final length = listState.objects.length;
    final totalLength = listState.hasMore ? null : length;

    // TODO: Handle error.

    return Material(
      type: MaterialType.canvas,
      color: AppStyle.lightboxBackgroundColor,
      child: SafeArea(
        child: GestureDetector(
          onTap: bloc.toggleControls,
          child: Stack(
            children: [
              PageView.builder(
                allowImplicitScrolling: true,
                controller: bloc.pagesBloc.pageController,
                itemCount: totalLength,
                itemBuilder: (context, index) {
                  final item = bloc.pagesBloc.getItemByIndex(index);
                  if (item != null) {
                    return _buildPage(item);
                  }
                  bloc.pagesBloc.listBloc.loadMoreIfCan();
                  return SmallCircularProgressIndicator();
                }
              ),
              ..._getStaticControls(blocState),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getStaticControls(ImagePagesBlocState blocState) {
    final result = <Widget>[];

    result.add(
      CloseImageOverlay(
        visible: blocState.controlsVisible,
        onPressed: bloc.closeScreen,
      ),
    );

    return result;
  }

  Widget _buildPage(PagesBlocItem<ImageEntity> item) {
    final urlTail = item.object.getLightboxUrl();
    if (urlTail == null) return IdErrorWidget(object: item.object);

    final url = 'https://courseplease.com' + urlTail;

    return Dismissible(
      key: ValueKey('page-' + item.index.toString()),
      direction: DismissDirection.down,
      onDismissed: (direction) => bloc.closeScreen(),
      child: Stack(
        children: [
          Center(
            child: Hero(
              tag: _getHeroTag(item.object),
              child: CachedNetworkImage(
                imageUrl: url,
                placeholder: (context, url) => SmallCircularProgressIndicator(),
                errorWidget: (context, url, error) => IdErrorWidget(object: item.object),
                fadeInDuration: Duration(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ..._buildOverlay(item),
        ],
      ),
    );
  }

  String _getHeroTag(ImageEntity image) {
    return 'image_${image.id}';
  }

  List<Widget> _buildOverlay(PagesBlocItem<ImageEntity> item) {
    if (imageOverlayBuilder == null) return [];

    return [imageOverlayBuilder!(item)];
  }
}

class ImagePagesGalleryScreen extends StatelessWidget {
  final ImagePagesGalleryBloc bloc;

  ImagePagesGalleryScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return ImagePagesScreen(
      bloc: bloc,
      imageOverlayBuilder: (item) => ImageOverlaysWidget(
        bloc: bloc,
        item: item,
        showAuthor: true,
        showReactions: true,
        onCommentPressed: bloc.onCommentPressed,
      ),
    );
  }
}

class ImagePagesTitlesScreen extends StatelessWidget {
  final ImagePagesTitlesBloc bloc;

  ImagePagesTitlesScreen({
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return ImagePagesScreen(
      bloc: bloc,
      imageOverlayBuilder: (item) => ImageOverlaysWidget(
        bloc: bloc,
        item: item,
      ),
    );
  }
}
