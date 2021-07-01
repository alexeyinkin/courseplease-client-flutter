import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/error/id.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/overlay.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:courseplease/widgets/teacher_rating_and_customer_count.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/filters/image.dart';
import '../../models/image.dart';
import '../../models/teacher.dart';

typedef List<Widget> ImageOverlayBuilder(BuildContext context, ImageEntity entity, bool controlsVisible);

// TODO: Move somewhere
const controlsAnimationDuration = Duration(milliseconds: 250);

class ImageLightboxScreen<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends StatefulWidget {
  final F filter;
  final int initialIndex;
  final ImageOverlayBuilder? imageOverlayBuilder;

  ImageLightboxScreen({
    required this.filter,
    required this.initialIndex,
    this.imageOverlayBuilder,
  });

  @override
  ImageLightboxScreenState<F, R> createState() => ImageLightboxScreenState(
    filter: filter,
    index: initialIndex,
  );
}

class ImageLightboxScreenState<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends State<ImageLightboxScreen<F, R>> {
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();

  late final PageController _pageController;
  final F filter;
  int index;
  bool _controlsVisible = true;

  ImageLightboxScreenState({
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
              tag: 'DISABLE-image_' + image.id.toString(),
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

class ImageTitleOverlay extends StatelessWidget {
  final ImageEntity image;
  final bool controlsVisible;

  ImageTitleOverlay({
    required this.image,
    required this.controlsVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (image.title == '') return Container();

    return Positioned(
      top: 10,
      left: 10,
      child: AnimatedOpacity(
        opacity: controlsVisible ? 1.0 : 0.0,
        duration: controlsAnimationDuration,
        child: RoundedOverlay(
          child: Text(
            image.title,
            style: AppStyle.imageTitle,
          ),
        ),
      ),
    );
  }
}

class ImageTeacherOverlay extends StatefulWidget {
  final int teacherId;
  final bool controlsVisible;

  ImageTeacherOverlay({
    required this.teacherId,
    required this.controlsVisible,
  });

  @override
  _ImageTeacherOverlayState createState() => _ImageTeacherOverlayState();
}

class _ImageTeacherOverlayState extends State<ImageTeacherOverlay> {
  final _teacherByIdBloc = ModelByIdBloc<int, Teacher>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Teacher, TeacherRepository>(),
  );

  @override
  void initState() {
    super.initState();
    _teacherByIdBloc.setCurrentId(widget.teacherId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ModelByIdState<int, Teacher>>(
      stream: _teacherByIdBloc.outState,
      builder: (context, snapshot) => _buildWithState(snapshot.data ?? _teacherByIdBloc.initialState),
    );
  }

  Widget _buildWithState(ModelByIdState<int, Teacher> teacherByIdState) {
    final teacher = teacherByIdState.object;

    return teacher == null
        ? _buildWithoutTeacher(teacherByIdState)
        : _buildWithTeacher(teacher);
  }

  Widget _buildWithoutTeacher(ModelByIdState<int, Teacher> teacherByIdState) {
    switch (teacherByIdState.requestStatus) {
      case RequestStatus.notTried:
      case RequestStatus.loading:
        return SmallCircularProgressIndicator();
      default:
        return Center(child: Icon(Icons.error));
    }
  }

  Widget _buildWithTeacher(Teacher teacher) {
    return Positioned(
      child: AnimatedOpacity(
        opacity: widget.controlsVisible ? 1.0 : 0.0,
        duration: controlsAnimationDuration,
        child: ImageTeacherTile(teacher: teacher),
      ),
      left: 10,
      bottom: 10,
    );
  }
}

class ViewImageLightboxScreenLauncher {
  static Future<void> show({
    required BuildContext context,
    required ViewImageFilter filter,
    required int initialIndex,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ImageLightboxScreen<ViewImageFilter, GalleryImageRepository>(
          filter: filter,
          initialIndex: initialIndex,
          imageOverlayBuilder: (context, image, controlsVisible) => [
            ImageTitleOverlay(image: image, controlsVisible: controlsVisible),
            ImageTeacherOverlay(teacherId: image.authorId, controlsVisible: controlsVisible),
          ],
        ),
      ),
    );
  }
}

// class ViewImageLightboxScreen extends AbstractImageLightboxScreen<ViewImageFilter, GalleryImageRepository> {
//   static const routeName = '/imageLightbox';
//
//   ViewImageLightboxScreen({
//     required ViewImageFilter filter,
//     required int initialIndex,
//   }) : super(
//     filter: filter,
//     initialIndex: initialIndex,
//   );
//
//   @override
//   State<AbstractImageLightboxScreen> createState() => _ViewImageLightboxScreenState(
//     filter: filter,
//     index: initialIndex,
//   );
// }
//
// class _ViewImageLightboxScreenState extends AbstractImageLightboxScreenState<ViewImageFilter, GalleryImageRepository> {
//   final _teacherByIdBloc = ModelByIdBloc<int, Teacher>(
//     modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Teacher, TeacherRepository>(),
//   );
//
//   _ViewImageLightboxScreenState({
//     required ViewImageFilter filter,
//     required int index,
//   }) : super(
//     filter: filter,
//     index: index,
//   );
//
//   @override
//   List<Widget> buildOverlays(BuildContext context, ImageEntity image) {
//     return [
//       buildTitleOverlay(context, image),
//       _buildTeacherOverlay(context, image.authorId),
//     ];
//   }
//
//   Widget _buildTeacherOverlay(BuildContext context, int teacherId) {
//     _teacherByIdBloc.setCurrentId(teacherId);
//     return StreamBuilder<ModelByIdState<int, Teacher>>(
//       stream: _teacherByIdBloc.outState,
//       builder: (context, snapshot) => _buildTeacherOverlayWithState(snapshot.data ?? _teacherByIdBloc.initialState),
//     );
//   }
//
//   Widget _buildTeacherOverlayWithState(ModelByIdState<int, Teacher> teacherByIdState) {
//     final teacher = teacherByIdState.object;
//
//     return teacher == null
//         ? _buildTeacherOverlayWithoutTeacher(teacherByIdState)
//         : _buildTeacherOverlayWithTeacher(teacher);
//   }
//
//   Widget _buildTeacherOverlayWithoutTeacher(ModelByIdState<int, Teacher> teacherByIdState) {
//     switch (teacherByIdState.requestStatus) {
//       case RequestStatus.notTried:
//       case RequestStatus.loading:
//         return SmallCircularProgressIndicator();
//       default:
//         return Center(child: Icon(Icons.error));
//     }
//   }
//
//   Widget _buildTeacherOverlayWithTeacher(Teacher teacher) {
//     return Positioned(
//       child: AnimatedOpacity(
//         opacity: _controlsVisible ? 1.0 : 0.0,
//         duration: AbstractImageLightboxScreenState.controlsAnimationDuration,
//         child: ImageTeacherTile(teacher: teacher),
//       ),
//       left: 10,
//       bottom: 10,
//     );
//   }
// }

class ImageLightboxScreenLauncher {
  static Future<void> showWithTitles<F extends AbstractFilter, R extends AbstractImageRepository<F>>({
    required BuildContext context,
    required F filter,
    required int initialIndex,
  }) {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => ImageLightboxScreen<F, R>(
          filter: filter,
          initialIndex: initialIndex,
          imageOverlayBuilder: (context, image, controlsVisible) => [
            ImageTitleOverlay(image: image, controlsVisible: controlsVisible),
          ],
        ),
      ),
    );
  }
}

// class EditImageLightboxScreen extends AbstractImageLightboxScreen<EditImageFilter, EditorImageRepository> {
//   static const routeName = '/unsortedImageLightbox';
//
//   EditImageLightboxScreen({
//     required EditImageFilter filter,
//     required int initialIndex,
//   }) : super(
//     filter: filter,
//     initialIndex: initialIndex,
//   );
//
//   @override
//   State<AbstractImageLightboxScreen> createState() => _EditImageLightboxScreenState(
//     filter: filter,
//     index: initialIndex,
//   );
// }
//
// class _EditImageLightboxScreenState extends AbstractImageLightboxScreenState<EditImageFilter, EditorImageRepository> {
//   _EditImageLightboxScreenState({
//     required EditImageFilter filter,
//     required int index,
//   }) : super(
//     filter: filter,
//     index: index
//   );
//
//   @override
//   List<Widget> buildOverlays(BuildContext context, ImageEntity image) {
//     return [
//       buildTitleOverlay(context, image),
//     ];
//   }
// }

// class FixedIdsImageLightboxScreen extends AbstractImageLightboxScreen<
//   IdsSubsetFilter<int, ImageEntity>,
//   AbstractImageRepository<IdsSubsetFilter<int, ImageEntity>>
// > {
//   static const routeName = '/fixedIdsImageLightbox';
//
//   FixedIdsImageLightboxScreen({
//     required IdsSubsetFilter<int, ImageEntity> filter,
//     required int initialIndex,
//   }) : super(
//     filter: filter,
//     initialIndex: initialIndex,
//   );
//
//   @override
//   State<AbstractImageLightboxScreen> createState() => _FixedIdsImageLightboxScreenState(
//     filter: filter,
//     index: initialIndex,
//   );
// }
//
// class _FixedIdsImageLightboxScreenState extends AbstractImageLightboxScreenState<
//   IdsSubsetFilter<int, ImageEntity>,
//   AbstractImageRepository<IdsSubsetFilter<int, ImageEntity>>
// > {
//   _FixedIdsImageLightboxScreenState({
//     required IdsSubsetFilter<int, ImageEntity> filter,
//     required int index,
//   }) : super(
//     filter: filter,
//     index: index,
//   );
//
//   @override
//   List<Widget> buildOverlays(BuildContext context, ImageEntity image) {
//     return [
//       buildTitleOverlay(context, image),
//     ];
//   }
// }

class ImageTeacherTile extends StatelessWidget {
  final Teacher teacher;
  ImageTeacherTile({
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    final relativeUrl = teacher.userpicUrls['300x300'] ?? null;
    final url = relativeUrl == null ? null : 'https://courseplease.com' + relativeUrl;

    return RoundedOverlay(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: url == null ? null : NetworkImage(url),
                  ),
                ),
                TeacherRatingAndCustomerCountWidget(teacher: teacher),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(teacher.firstName + ' ' + teacher.lastName + ' ' + teacher.id.toString(), style: TextStyle(fontWeight: FontWeight.bold))
              ),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                child: LocationLineWidget(location: teacher.location, textOpacity: .5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
