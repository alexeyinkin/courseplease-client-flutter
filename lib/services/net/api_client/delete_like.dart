import 'package:courseplease/services/net/api_client.dart';
import 'package:courseplease/services/net/api_client/like_action_response.dart';

extension DeleteLike on ApiClient {
  Future<LikeActionResponse> deleteLike(DeleteLikeRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/gallery/likes/delete',
      body: request,
    );
    return LikeActionResponse.fromMap(mapResponse.data);
  }
}

class DeleteLikeRequest extends RequestBody {
  final String catalog;
  final int objectId;

  DeleteLikeRequest({
    required this.catalog,
    required this.objectId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'catalog': catalog,
      'objectId': objectId,
    };
  }
}
