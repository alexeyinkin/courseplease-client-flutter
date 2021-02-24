import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

class ImageListActionCubit extends ListActionCubit<int, MediaSortActionEnum> {
  final _apiClient = GetIt.instance.get<ApiClient>();

  static const _mediaType = 'image';

  Future move(SelectableListState selectableListState, EditImageFilter setFilter) async {
    setActionInProgress(MediaSortActionEnum.unlink);
    final future = _apiClient.sortMedia(_getMoveRequest(selectableListState, setFilter));
    _programFuture(future);

    return future;
  }

  MediaSortRequest _getMoveRequest(SelectableListState selectableListState, EditImageFilter setFilter) {
    final commands = <MediaSortCommand>[];
    for (final id in selectableListState.selectedIds.keys) {
      commands.add(_getMoveCommand(id, selectableListState.filter, setFilter));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getMoveCommand(int id, EditImageFilter fetchFilter, EditImageFilter setFilter) {
    return MediaSortCommand(
      type: _mediaType,
      id: id,
      action: enumValueAfterDot(MediaSortActionEnum.move),
      fetchFilter: fetchFilter,
      setFilter: setFilter,
    );
  }

  Future link(List<int> imageIds, EditImageFilter setFilter) async {
    setActionInProgress(MediaSortActionEnum.unlink);
    final future = _apiClient.sortMedia(_getLinkRequest(imageIds, setFilter));
    _programFuture(future);

    return future;
  }

  MediaSortRequest _getLinkRequest(List<int> imageIds, EditImageFilter setFilter) {
    final commands = <MediaSortCommand>[];
    for (final id in imageIds) {
      commands.add(_getLinkCommand(id, setFilter));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getLinkCommand(int id, EditImageFilter setFilter) {
    return MediaSortCommand(
      type: _mediaType,
      id: id,
      action: enumValueAfterDot(MediaSortActionEnum.link),
      setFilter: setFilter,
    );
  }

  Future unlink(SelectableListState selectableListState) async {
    setActionInProgress(MediaSortActionEnum.unlink);
    final future = _apiClient.sortMedia(_getUnlinkRequest(selectableListState));
    _programFuture(future);

    return future;
  }

  MediaSortRequest _getUnlinkRequest(SelectableListState selectableListState) {
    final commands = <MediaSortCommand>[];
    for (final id in selectableListState.selectedIds.keys) {
      commands.add(_getUnlinkCommand(id, selectableListState.filter));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getUnlinkCommand(int id, EditImageFilter filter) {
    return MediaSortCommand(
      type: _mediaType,
      id: id,
      action: enumValueAfterDot(MediaSortActionEnum.unlink),
      fetchFilter: filter,
    );
  }

  void _programFuture(Future future) {
    future
        .then(_onRequestSuccess)
        .catchError(_onRequestError);
  }

  void _onRequestSuccess(_) {
    setActionInProgress(null);
    // TODO: Update this and possibly other lists.
  }

  void _onRequestError(_) {
    setActionInProgress(null);
    // TODO: Push some error message somewhere.
  }
}
