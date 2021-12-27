import 'package:courseplease/blocs/list_action/media_sort_list_action.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/sort_media.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:get_it/get_it.dart';

mixin LinkListActionMixin<I, F extends AbstractFilter> on MediaSortListActionCubitInterface<I> {
  Future<void> link(List<I> ids, F setFilter) async {
    setActionInProgress(MediaSortActionEnum.unlink);

    final apiClient = GetIt.instance.get<ApiClient>();

    try {
      await apiClient.sortMedia(_getLinkRequest(ids, setFilter));
      onRequestSuccess();
    } catch (ex) {
      onRequestError();
    }
  }

  MediaSortRequest _getLinkRequest(List<I> ids, F setFilter) {
    final commands = <MediaSortCommand>[];
    for (final id in ids) {
      commands.add(_getLinkCommand(id, setFilter));
    }
    return MediaSortRequest(commands: commands);
  }

  MediaSortCommand _getLinkCommand(I id, F setFilter) {
    return MediaSortCommand(
      type: getMediaType(),
      id: id,
      action: MediaSortActionEnum.link.name,
      setFilter: setFilter,
    );
  }
}
