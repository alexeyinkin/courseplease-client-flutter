import 'package:cached_network_image/cached_network_image.dart';
import 'package:courseplease/repositories/lesson.dart';
import 'package:courseplease/theme/theme.dart';
import 'package:courseplease/widgets/abstract_object_tile.dart';
import 'package:courseplease/widgets/duration.dart';
import 'package:flutter/rendering.dart';
import '../screens/lesson/lesson.dart';
import '../models/filters/lesson.dart';
import '../models/interfaces.dart';
import '../models/lesson.dart';
import 'object_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LessonGrid extends StatefulWidget {
  LessonFilter filter;
  final Axis scrollDirection;
  final int crossAxisCount;
  Widget titleIfNotEmpty; // Nullable

  LessonGrid({
    @required this.filter,
    @required this.scrollDirection,
    @required this.crossAxisCount,
    this.titleIfNotEmpty,
  }) : super(key: ValueKey(filter.subjectId));

  @override
  State<LessonGrid> createState() {
    return new LessonGridState();
  }
}

class LessonGridState extends State<LessonGrid> {
  final padding = 10.0;

  @override
  Widget build(BuildContext context) {
    return _isFilterValid(widget.filter)
        ? _buildWithFilter()
        : Container();
  }

  static bool _isFilterValid(LessonFilter filter) {
    return filter.subjectId != null;
  }

  Widget _buildWithFilter() {
    return Container(
      padding: EdgeInsets.all(padding),
      child: ObjectGrid<int, Lesson, LessonFilter, LessonRepository, LessonTile>(
        filter: widget.filter,
        tileFactory: ({Lesson object, int index, TileCallback<int, Lesson> onTap}) => LessonTile(object: object, filter: widget.filter, index: index, onTap: onTap),
        titleIfNotEmpty: widget.titleIfNotEmpty,

        // When using Lesson as argument type, for some reason an exception is thrown
        // at tile construction in ObjectGird in GridView.builder:
        //
        // type '(Lesson, int) => Null' is not a subtype of type '(WithId<dynamic>, int) => void'
        // TODO: Find the reason for the exception, change the argument type to Lesson.
        onTap: (WithId lesson, int index) {
          if (lesson is Lesson) {
            _handleTap(lesson, index);
          } else {
            throw Exception('A lesson is not Lesson');
          }
        },

        scrollDirection: widget.scrollDirection,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: padding,
          crossAxisSpacing: padding,
          childAspectRatio: 1.2,
        ),
      ),
    );
  }

  void _handleTap(Lesson lesson, int index) {
    Navigator.of(context).pushNamed(
      LessonScreen.routeName,
      arguments: LessonScreenArguments(
        id: lesson.id,
        autoplay: true, // TODO: No autoplay if tapped the title and not the cover.
      ),
    );
  }
}

class LessonTile extends AbstractObjectTile<int, Lesson, LessonFilter> {
  LessonTile({
    @required object,
    @required filter,
    @required index,
    onTap,
  }) : super(
    object: object,
    filter: filter,
    index: index,
    onTap: onTap,
  );

  @override
  State<AbstractObjectTile> createState() => LessonTileState();
}

class LessonTileState extends AbstractObjectTileState<int, Lesson, LessonFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Column(
        children: [
          GestureDetector(
            onTap: _handleCoverTap,
            child: Container(
              padding: EdgeInsets.only(bottom: 5),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _getCoverContent(),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _handleTitleTap,
                  child: Text(
                    widget.object.title,
                    style: AppStyle.lessonTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getCoverContent() {
    switch (widget.object.type) {
      case 'text':
        return _getTextCoverContent();
      case 'video':
        return _getVideoCoverContent();
    }

    return Text("Unknown lesson type: " + widget.object.type);
  }

  Widget _getVideoCoverContent() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Stack(
        children: [
          Positioned(top: 0, bottom: 0, left: 0, right: 0, child: _getTextCoverContent()),
          Center(
            child: Opacity(
              opacity: .7,
              child: Icon(
                Icons.play_circle_fill,
                size: 64,
              ),
            ),
          ),
          Positioned(
            right: 3,
            bottom: 3,
            child: DurationWidget(duration: Duration(seconds: widget.object.durationSeconds)),
          ),
        ],
      ),
    );
  }

  Widget _getTextCoverContent() {
    return CachedNetworkImage(
      imageUrl: _getUrl(),
      fit: BoxFit.cover,
    );
  }

  void _handleCoverTap() {
    _handleTap();
  }

  void _handleTitleTap() {
    _handleTap();
  }

  void _handleTap() {
    widget.onTap(widget.object, widget.index);
  }

  String _getUrl() {
    return 'https://courseplease.com' + widget.object.coverUrls['1920x1080'];
  }
}
