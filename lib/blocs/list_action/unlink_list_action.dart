import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/sort_media.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

import '../selectable_list.dart';

mixin UnlinkListActionMixin<I, F extends AbstractFilter> on MediaSortListActionCubitInterface<I> {
  Future<void> unlink(
    SelectableListState<I, F> selectableListState,
  ) async {
    setActionInProgress(MediaSortActionEnum.unlink);

    final apiClient = GetIt.instance.get<ApiClient>();

    try {
      await apiClient.sortMedia(_getUnlinkRequest(selectableListState));
      onRequestSuccess();
      removeIds(selectableListState.selectedIds.keys.toList());
    } catch (ex) {
      onRequestError();
    }
  }

  MediaSortRequest _getUnlinkRequest(
    SelectableListState<I, F> selectableListState,
  ) {
    final commands = <MediaSortCommand>[];
    for (final id in selectableListState.selectedIds.keys) {
      commands.add(_getUnlinkCommand(id, selectableListState.filter));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getUnlinkCommand(I id, F filter) {
    return MediaSortCommand(
      type: getMediaType(),
      id: id,
      action: MediaSortActionEnum.unlink.name,
      fetchFilter: filter,
    );
  }
}
