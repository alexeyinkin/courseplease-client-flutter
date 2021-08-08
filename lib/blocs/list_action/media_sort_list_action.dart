import 'dart:convert';

import 'package:courseplease/blocs/list_action/list_action.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/interfaces.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/filtered_model_list_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../authentication.dart';
import '../filtered_model_list.dart';

abstract class MediaSortListActionCubitInterface<I> {
  void setActionInProgress(MediaSortActionEnum action);

  @protected
  String getMediaType();

  @protected
  void onRequestSuccess();

  @protected
  void removeIds(List<I> ids);

  @protected
  void onRequestError();
}

abstract class MediaSortListActionCubit<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>
> extends ListActionCubit<I, MediaSortActionEnum>
  implements MediaSortListActionCubitInterface<I>
{
  final F filter;

  final _authenticationCubit = GetIt.instance.get<AuthenticationBloc>();
  final _filteredModelListCache = GetIt.instance.get<FilteredModelListCache>();

  final _errorsController = BehaviorSubject<void>();
  Stream<void> get errors => _errorsController.stream;

  MediaSortListActionCubit({
    required this.filter,
  });

  @override
  void dispose() {
    _errorsController.close();
    super.dispose();
  }

  @protected
  void onRequestSuccess() {
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

  void _clearAllOtherImageLists() {

    final listsByFilterTypes = _filteredModelListCache.getNetworkModelListsByObjectType<O>();
    final currentFilterJson = jsonEncode(filter);

    for (final listsByFilters in listsByFilterTypes.values) {
      for (final entry in listsByFilters.entries) {
        if (entry.key == currentFilterJson) continue;
        entry.value.clearAndLoadFirstPage();
      }
    }
  }

  @protected
  void removeIds(List<I> ids) {
    final list = _getCurrentModelList();
    list.removeObjectIds(ids);
  }

  NetworkFilteredModelListBloc<I, O, F> _getCurrentModelList() {
    final cache = GetIt.instance.get<FilteredModelListCache>();
    return cache.getOrCreateNetworkList<I, O, F, R>(filter);
  }

  @protected
  void onRequestError() {
    setActionInProgress(null);
    _errorsController.sink.add(true);
  }

  void synchronizeProfile(int contactId) async {
    setActionInProgress(MediaSortActionEnum.synchronize);
    await _authenticationCubit.synchronizeProfileSynchronously(contactId);
    setActionInProgress(null);
    _clearAllImageLists(); // TODO: Clear only if anything new is fetched.
  }

  void synchronizeProfiles() async {
    setActionInProgress(MediaSortActionEnum.synchronize);
    await _authenticationCubit.synchronizeProfilesSynchronously();
    setActionInProgress(null);
    _clearAllImageLists(); // TODO: Clear only if anything new is fetched.
  }

  void _clearAllImageLists() {
    final listsByFilterTypes = _filteredModelListCache.getNetworkModelListsByObjectType<O>();

    for (final listsByFilters in listsByFilterTypes.values) {
      for (final list in listsByFilters.values) {
        list.clearAndLoadFirstPage();
      }
    }
  }
}

enum MediaSortActionEnum {
  move,
  link,
  unlink,
  delete,
  synchronize,
}
