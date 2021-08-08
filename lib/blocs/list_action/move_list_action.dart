import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/sort_media.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

import '../selectable_list.dart';

mixin MoveListActionMixin<I, F extends AbstractFilter> on MediaSortListActionCubitInterface<I> {
  Future<void> move(
    SelectableListState<I, F> selectableListState,
    F setFilter,
  ) async {
    setActionInProgress(MediaSortActionEnum.unlink);

    final apiClient = GetIt.instance.get<ApiClient>();

    try {
      await apiClient.sortMedia(_getMoveRequest(selectableListState, setFilter));
      onRequestSuccess();
      removeIds(selectableListState.selectedIds.keys.toList());
    } catch (ex) {
      onRequestError();
    }
  }

  MediaSortRequest _getMoveRequest(
    SelectableListState<I, F> selectableListState,
    F setFilter,
  ) {
    final commands = <MediaSortCommand>[];
    for (final id in selectableListState.selectedIds.keys) {
      commands.add(_getMoveCommand(id, selectableListState.filter, setFilter));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getMoveCommand(I id, F fetchFilter, F setFilter) {
    return MediaSortCommand(
      type: getMediaType(),
      id: id,
      action: enumValueAfterDot(MediaSortActionEnum.move),
      fetchFilter: fetchFilter,
      setFilter: setFilter,
    );
  }
}
