import 'dart:convert';
import 'package:courseplease/blocs/authentication.dart';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/blocs/list_action.dart';
import 'package:courseplease/blocs/selectable_list.dart';
import 'package:courseplease/models/filters/image.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/repositories/image.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

class ImageListActionCubit extends ListActionCubit<int, MediaSortActionEnum> {
  final EditImageFilter filter;
  final _apiClient = GetIt.instance.get<ApiClient>();
  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();

  static const _mediaType = 'image';

  ImageListActionCubit({
    @required this.filter,
  });

  Future<void> move(SelectableListState selectableListState, EditImageFilter setFilter) async {
    setActionInProgress(MediaSortActionEnum.unlink);
    final future = _apiClient.sortMedia(_getMoveRequest(selectableListState, setFilter));

    return future
        .then(_onRequestSuccess)
        .then((_) => _removeImageIds(selectableListState.selectedIds.keys.toList()))
        .catchError(_onRequestError);
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

  Future<void> link(List<int> imageIds, EditImageFilter setFilter) async {
    setActionInProgress(MediaSortActionEnum.unlink);
    final future = _apiClient.sortMedia(_getLinkRequest(imageIds, setFilter));
    future
        .then(_onRequestSuccess)
        .catchError(_onRequestError);

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

  Future<void> unlink(SelectableListState selectableListState) async {
    setActionInProgress(MediaSortActionEnum.unlink);
    final future = _apiClient.sortMedia(_getUnlinkRequest(selectableListState));
    future
        .then(_onRequestSuccess)
        .then((_) => _removeImageIds(selectableListState.selectedIds.keys.toList()))
        .catchError(_onRequestError);

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

  void _onRequestSuccess(_) {
    setActionInProgress(null);
    _authenticationCubit.reloadCurrentActor(); // Could have added teaching subjects.
    // TODO: Reload only if really added. Check this when creating 'link' and 'move' commands.

    // TODO: Make a more granular clearing.
    //       We have image IDs. One way is to go through all the lists
    //       and to re-validate if images with those IDs still match the list's filter.
    //       Also add images if they were not matching the filter but started to match.
    //       Though list ordering is challenging in this process.
    _clearAllOtherImageLists();
  }

  void _removeImageIds(List<int> imageIds) {
    final list = _getCurrentModelList();
    list.removeObjectIds(imageIds);
  }

  NetworkFilteredModelListBloc<int, ImageEntity, EditImageFilter> _getCurrentModelList() {
    return _filteredModelListCache.getOrCreate<int, ImageEntity, EditImageFilter, EditorImageRepository>(filter);
  }

  void _clearAllOtherImageLists() {
    final listsByFilterTypes = _filteredModelListCache.getNetworkModelListsByObjectType<ImageEntity>();
    final currentFilterJson = jsonEncode(filter);

    for (final listsByFilters in listsByFilterTypes.values) {
      for (final filterJson in listsByFilters.keys) {
        if (filterJson == currentFilterJson) {
          continue;
        }

        listsByFilters[filterJson].clearAndLoadFirstPage();
      }
    }
  }

  void _onRequestError(_) {
    setActionInProgress(null);
    // TODO: Push some error message somewhere.
  }
}
