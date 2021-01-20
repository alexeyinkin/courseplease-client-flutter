import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/model_by_id.dart';
import 'package:courseplease/repositories/photo.dart';
import 'package:courseplease/repositories/teacher.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/model_cache_factory.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/location_line.dart';
import 'package:courseplease/widgets/rating_and_vote_count.dart';
import 'package:courseplease/widgets/small_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../models/filters/photo.dart';
import '../../models/photo.dart';
import '../../models/teacher.dart';

class PhotoLightboxScreen extends StatefulWidget {
  static const routeName = '/photoLightbox';

  @override
  State<PhotoLightboxScreen> createState() {
    return PhotoLightboxScreenState();
  }
}

class PhotoLightboxScreenState extends State<PhotoLightboxScreen> {
  final _filteredModelListFactory = GetIt.instance.get<FilteredModelListFactory>();

  final _teacherByIdBloc = ModelByIdBloc<int, Teacher>(
    modelCacheBloc: GetIt.instance.get<ModelCacheFactory>().getOrCreate<int, Teacher, TeacherRepository>(),
  );

  PageController _pageController;
  PhotoFilter _filter;
  int _index;
  bool _controlsVisible = true;

  static const _controlsAnimationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    _parseArgumentsIfNot(context);
    final listBloc = _filteredModelListFactory.getOrCreate<int, Photo, PhotoFilter, PhotoRepository>(_filter);

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

  Widget _buildWithListState(BuildContext context, ModelListState<Photo> listState, FilteredModelListBloc bloc) {
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

  Widget _buildPage(BuildContext context, ModelListState<Photo> listState, int index) {
    final photo = listState.objects[index];
    final url = 'https://courseplease.com' + photo.getLightboxUrl();

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
              tag: 'DISABLE-photo-' + photo.id.toString(),
              child: CachedNetworkImage(
                imageUrl: url,
                placeholder: (context, url) => SmallCircularProgressIndicator(),
                errorWidget: (context, url, error) => Row(children:[Icon(Icons.error), Text(photo.id.toString())]),
                fadeInDuration: Duration(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildTitleOverlay(context, photo),
          _buildTeacherOverlay(context, photo.authorId),
        ],
      ),
    );
  }

  Widget _buildTitleOverlay(BuildContext context, Photo photo) {
    if (photo.title == '') return Container();

    return Positioned(
      top: 10,
      left: 10,
      child: AnimatedOpacity(
        opacity: _controlsVisible ? 1.0 : 0.0,
        duration: _controlsAnimationDuration,
        child: PhotoLightboxOverlay(
          child: Text(
            //'Title: ' + photo.title,
            photo.title,
            style: AppStyle.photoTitle,
          ),
        ),
      ),
    );
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
        duration: _controlsAnimationDuration,
        child: PhotoTeacherTile(teacher: teacher),
      ),
      left: 10,
      bottom: 10,
    );
  }

  void _parseArgumentsIfNot(BuildContext context) {
    if (_filter == null) {
      final arguments = ModalRoute.of(context).settings.arguments as PhotoLightboxArguments;
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

class PhotoLightboxArguments {
  final PhotoFilter filter;
  final int index;

  PhotoLightboxArguments({
    this.filter,
    this.index,
  });
}

class PhotoTeacherTile extends StatelessWidget {
  final Teacher teacher;
  PhotoTeacherTile({@required this.teacher});

  @override
  Widget build(BuildContext context) {
    final relativeUrl = teacher.userpicUrls['300x300'] ?? null;
    final url = relativeUrl == null ? null : 'https://courseplease.com' + relativeUrl;

    return PhotoLightboxOverlay(
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

class PhotoLightboxOverlay extends StatelessWidget {
  final Widget child;

  PhotoLightboxOverlay({this.child});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(96, 0, 0, 0),
        ),
        child: child,
      ),
    );
  }
}
