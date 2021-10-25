import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/services/suggest/abstract.dart';
import 'package:get_it/get_it.dart';
import 'package:model_interfaces/model_interfaces.dart';

class RepositorySuggestionService<
  I,
  O extends WithId<I>,
  F extends AbstractFilter,
  R extends AbstractFilteredRepository<I, O, F>
> extends AbstractSuggestionService<O> {
  final F fixedFilter;
  final F Function(F fixedFilter, String search) filterBuilder;

  RepositorySuggestionService({
    required this.fixedFilter,
    required this.filterBuilder,
  });

  @override
  Future<List<O>> suggest(String str) async {
    final filter = filterBuilder(fixedFilter, str);
    final repository = GetIt.instance.get<R>();

    final loadResult = await repository.loadWithFilter(filter, null);
    return loadResult.objects;
  }
}
