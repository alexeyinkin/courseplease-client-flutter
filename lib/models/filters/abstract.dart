import 'dart:convert';
import 'package:courseplease/blocs/filtered_model_list.dart';
import 'package:courseplease/services/net/api_client.dart';
import 'package:model_interfaces/model_interfaces.dart';

abstract class AbstractFilter implements JsonSerializable {
  @override
  String toString() {
    return jsonEncode(this);
  }
}

class IdsSubsetFilter<I, O extends WithId<I>> extends AbstractFilter {
  final List<I> ids;
  final AbstractFilteredModelListBloc<I, O, AbstractFilter> nestedList;

  IdsSubsetFilter({
    required this.ids,
    required this.nestedList,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'ids': ids,
      'nestedListFilter': nestedList.filter,
    };
  }
}
