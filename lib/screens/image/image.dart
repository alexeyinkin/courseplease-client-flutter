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
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/overlay.dart';
import 'package:courseplease/widgets/rating_and_vote_count.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/filters/image.dart';
import '../../models/image.dart';
import '../../models/teacher.dart';

abstract class AbstractImageLightboxScreen<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends StatefulWidget {
}

abstract class AbstractImageLightboxScreenState<
  F extends AbstractFilter,
  R extends AbstractImageRepository<F>
> extends State<AbstractImageLightboxScreen<F, R>> {
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();

  PageController _pageController;
  F _filter;
  int _index;
  bool _controlsVisible = true;

  @protected
  static const controlsAnimationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    _parseArgumentsIfNot(context);
    final listBloc = _filteredModelListCache.getOrCreate<int, ImageEntity, F, R>(_filter);

    return StreamBuilder(
      stream: listBloc.outState,
      initialData: listBloc.initialState,
      builder: (context, snapshot) {
        return _buildWithListState(
          context,
          snapshot.data,
          listBloc,
        );
      },
    );
  }

  Widget _buildWithListState(
    BuildContext context,
    ModelListState<int, ImageEntity> listState,
    FilteredModelListBloc bloc,
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
    final url = 'https://courseplease.com' + image.getLightboxUrl();

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
                errorWidget: (context, url, error) => Row(children:[Icon(Icons.error), Text(image.id.toString())]),
                fadeInDuration: Duration(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ...buildOverlays(context, image),
        ],
      ),
    );
  }

  @protected
  List<Widget> buildOverlays(BuildContext context, ImageEntity image) {
    return <Widget>[];
  }

  @protected
  Widget buildTitleOverlay(BuildContext context, ImageEntity image) {
    if (image.title == '') return Container();

    return Positioned(
      top: 10,
      left: 10,
      child: AnimatedOpacity(
        opacity: _controlsVisible ? 1.0 : 0.0,
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

  void _parseArgumentsIfNot(BuildContext context) {
    if (_filter == null) {
      final arguments = ModalRoute.of(context).settings.arguments as ImageLightboxArguments<F>;
      _filter = arguments.filter;
      _index = arguments.index;
      _pageController = PageController(
        initialPage: _index,
      );
    }
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
  }
}

class ViewImageLightboxScreen extends AbstractImageLightboxScreen<ViewImageFilter, GalleryImageRepository> {
  static const routeName = '/photoLightbox';

  @override
  State<AbstractImageLightboxScreen> createState() => ViewImageLightboxScreenState();
}

class ViewImageLightboxScreenState extends AbstractImageLightboxScreenState<ViewImageFilter, GalleryImageRepository> {
  final _teacherByIdBloc = ModelByIdBloc<int, Teacher>(
    modelCacheBloc: GetIt.instance.get<ModelCacheCache>().getOrCreate<int, Teacher, TeacherRepository>(),
  );

  @override
  List<Widget> buildOverlays(BuildContext context, ImageEntity image) {
    return [
      buildTitleOverlay(context, image),
      _buildTeacherOverlay(context, image.authorId),
    ];
  }

  Widget _buildTeacherOverlay(BuildContext context, int teacherId) {
    _teacherByIdBloc.setCurrentId(teacherId);
    return StreamBuilder(
      stream: _teacherByIdBloc.outState,
      initialData: _teacherByIdBloc.initialState,
      builder: (context, snapshot) => _buildTeacherOverlayWithState(snapshot.data),
    );
  }

  Widget _buildTeacherOverlayWithState(ModelByIdState<int, Teacher> teacherByIdState) {
    final teacher = teacherByIdState.object;

    return teacher == null
        ? _buildTeacherOverlayWithoutTeacher(teacherByIdState)
        : _buildTeacherOverlayWithTeacher(teacher);
  }

  Widget _buildTeacherOverlayWithoutTeacher(ModelByIdState<int, Teacher> teacherByIdState) {
    switch (teacherByIdState.requestStatus) {
      case RequestStatus.notTried:
      case RequestStatus.loading:
        return SmallCircularProgressIndicator();
      default:
        return Center(child: Icon(Icons.error));
    }
  }

  Widget _buildTeacherOverlayWithTeacher(Teacher teacher) {
    return Positioned(
      child: AnimatedOpacity(
        opacity: _controlsVisible ? 1.0 : 0.0,
        duration: AbstractImageLightboxScreenState.controlsAnimationDuration,
        child: ImageTeacherTile(teacher: teacher),
      ),
      left: 10,
      bottom: 10,
    );
  }
}

class EditImageLightboxScreen extends AbstractImageLightboxScreen<EditImageFilter, EditorImageRepository> {
  static const routeName = '/unsortedPhotoLightbox';

  @override
  State<AbstractImageLightboxScreen> createState() => EditImageLightboxScreenState();
}

class EditImageLightboxScreenState extends AbstractImageLightboxScreenState<EditImageFilter, EditorImageRepository> {
  @override
  List<Widget> buildOverlays(BuildContext context, ImageEntity image) {
    return [
      buildTitleOverlay(context, image),
    ];
  }
}

class ImageLightboxArguments<F extends AbstractFilter> {
  final F filter;
  final int index;

  ImageLightboxArguments({
    this.filter,
    this.index,
  });
}

class ImageTeacherTile extends StatelessWidget {
  final Teacher teacher;
  ImageTeacherTile({
    @required this.teacher,
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
                RatingAndVoteCountWidget(rating: teacher.rating, hideIfEmpty: true),
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
