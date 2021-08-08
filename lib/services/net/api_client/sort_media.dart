import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/services/net/api_client.dart';

extension SortMedia on ApiClient {
  Future sortMedia(MediaSortRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/sort',
      body: request,
    );

    return mapResponse;
  }
}

class MediaSortRequest extends RequestBody {
  final List<MediaSortCommand> commands;

  MediaSortRequest({
    required this.commands,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'commands': commands,
    };
  }
}

class MediaSortCommand<I, F extends AbstractFilter> extends JsonSerializable {
  final String type;
  final I id;
  final String action;
  final F? fetchFilter;
  final F? setFilter;

  MediaSortCommand({
    required this.type,
    required this.id,
    required this.action,
    this.fetchFilter,
    this.setFilter,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'type':         type,
      'id':           id,
      'action':       action,
      'fetchFilter':  fetchFilter?.toJson() ?? {},
      'setFilter':    setFilter?.toJson() ?? {},
    };
  }
}
