import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:courseplease/models/contact/editable_contact.dart';
import 'package:courseplease/models/filters/abstract.dart';
import 'package:courseplease/models/image.dart';
import 'package:courseplease/models/messaging/message_body.dart';
import 'package:courseplease/models/messaging/time_offer_message_body.dart';
import 'package:courseplease/models/network_request_info.dart';
import 'package:courseplease/models/shop/line_item.dart';
import 'package:courseplease/models/shop/money_account.dart';
import 'package:courseplease/models/sse/server_sent_event.dart';
import 'package:courseplease/models/teacher_subject.dart';
import 'package:courseplease/models/user.dart';
import 'package:courseplease/repositories/abstract.dart';
import 'package:courseplease/utils/auth/app_info.dart';
import 'package:courseplease/utils/auth/device_info_for_server.dart';
import 'package:courseplease/utils/utils.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String host = 'courseplease.com';
  static const _authorizationHeader = 'Authorization';

  String? _deviceKey;
  String _lang;

  ApiClient({
    required String lang,
  }) :
      _lang = lang
  ;

  void setDeviceKey(String? deviceKey) {
    _deviceKey = deviceKey;
  }

  void setLang(String lang) {
    _lang = lang;
  }

  Future<RegisterDeviceResponseData> registerDevice(RegisterDeviceRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/auth/registerDevice',
      body: request,
    );
    return RegisterDeviceResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> getMe() async {
    final mapResponse = await sendRequest(
      method: HttpMethod.get,
      path: '/api1/me',
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> getMeByDeviceKey(String overrideDeviceKey) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.get,
      path: '/api1/me',
      headers: {_authorizationHeader: _getBearerAuthorizationHeaderValue(overrideDeviceKey)},
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> saveProfile(SaveProfileRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/me/saveProfile',
      body: request,
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> saveContactParams(SaveContactParamsRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/me/saveContactParams',
      body: request,
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> syncProfileSync(int contactId) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/me/syncProfileSync/' + contactId.toString(),
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> syncAllProfilesSync() async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/me/syncAllProfilesSync',
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<MeResponseData> saveConsultingProduct(SaveConsultingProductRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/me/saveConsultingProduct',
      body: request,
    );
    return MeResponseData.fromMap(mapResponse.data);
  }

  Future<GetServerSentEventsResponse> getServerSentEvents(int lastSseId) async {
    final request = {'lastEventId': lastSseId};
    final mapResponse = await sendRequest(
      method: HttpMethod.get,
      path: '/api1/{@lang}/me/sse',
      queryParameters: {'request': jsonEncode(request)},
    );
    return GetServerSentEventsResponse.fromMap(mapResponse.data);
  }

  Future<SendChatMessageResponse> sendChatMessage(SendChatMessageRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/chats/send',
      body: request,
    );
    return SendChatMessageResponse.fromMap(mapResponse.data);
  }

  Future<void> markChatMessagesRead(MarkChatMessagesReadRequest request) async {
    await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/chats/read',
      body: request,
    );
  }

  Future<CreateCartAndOrderResponse> getOrCreateOrderAndPay(
    CreateCartAndOrderRequest request,
  ) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/shop/get-or-create-order-and-pay',
      body: request,
    );
    return CreateCartAndOrderResponse.fromMap(mapResponse.data);
  }

  Future<void> updateTimeSlots(
    TimeOfferMessageBody request,
  ) async {
    await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/lms/update-slots',
      body: request,
    );
  }

  Future<void> reviewDeliveryAsCustomer(
    ReviewDeliveryRequest request,
  ) async {
    await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/shop/review-delivery-as-customer',
      body: request,
    );
  }

  Future<void> reviewDeliveryAsSeller(
    ReviewDeliveryRequest request,
  ) async {
    await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/shop/review-delivery-as-seller',
      body: request,
    );
  }

  Future<void> agreeToRefund(
    DeliveryRequest request,
  ) async {
    await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/shop/agree-to-refund',
      body: request,
    );
  }

  Future<void> insistToGetMoney(
    DeliveryRequest request,
  ) async {
    await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/shop/insist-to-get-money',
      body: request,
    );
  }

  Future<GeoCodeResponse> geoCode(
    GeoCodeRequest request,
  ) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/geo/geocode',
      body: request,
    );
    return GeoCodeResponse.fromMap(mapResponse.data);
  }

  Future<ImageEntity> uploadUserpic(Uint8List bytes) async {
    final str = await sendFile(
      path: '/api1/{@lang}/i/userpic',
      bytes: bytes,
    );

    final map = jsonDecode(str);
    return ImageEntity.fromMap(map['data']);
  }

  Future<CreateCommentResponse> createComment(CreateCommentRequest request) async {
    final mapResponse = await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/gallery/comments/create',
      body: request,
    );
    return CreateCommentResponse.fromMap(mapResponse.data);
  }

  Future<void> deleteComment(DeleteCommentRequest request) async {
    await sendRequest(
      method: HttpMethod.post,
      path: '/api1/{@lang}/gallery/comments/delete',
      body: request,
    );
  }

  Future<SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>> getAllEntities(String name) async {
    return _createListLoadResultResponse(
      await sendRequest(
        method: HttpMethod.get,
        path: '/api1/{@lang}/' + name,
      ),
    );
  }

  Future<SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>> getEntities({
    required String name,
    required AbstractFilter filter,
    required String? pageToken,
    Map<String, String>? queryParameters,
  }) async {
    if (queryParameters == null) {
      queryParameters = Map<String, String>();
    }

    queryParameters['filter'] = filter.toString();

    if (pageToken != null) {
      queryParameters['pageToken'] = pageToken;
    }

    return _createListLoadResultResponse(
      await sendRequest(
        method: HttpMethod.get,
        path: '/api1/{@lang}/' + name,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<SuccessfulApiResponse<Map<String, dynamic>>> getEntity<I>(
    String name,
    I id,
  ) async {
    return await sendRequest(
      method: HttpMethod.get,
      path: '/api1/{@lang}/' + name + '/' + id.toString(),
    );
  }

  SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>> _createListLoadResultResponse(SuccessfulApiResponse<Map<String, dynamic>> mapResponse) {
    return SuccessfulApiResponse<ListLoadResult<Map<String, dynamic>>>(
      data: _createListLoadResult(mapResponse.data),
    );
  }

  ListLoadResult<Map<String, dynamic>> _createListLoadResult(Map<String, dynamic> dataMap) {
    final items = dataMap['items'].cast<Map<String, dynamic>>();
    final nextPageToken = dataMap['nextPageToken'];

    return ListLoadResult(items, nextPageToken);
  }

  Future<SuccessfulApiResponse<Map<String, dynamic>>> sendRequest({
    required HttpMethod method,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    RequestBody? body,
  }) async {
    if (headers == null) headers = Map<String, String>();

    final responseMap = await sendMap(
      method: method,
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      body: body?.toJson(),
    );

    final int status = responseMap['status'];

    if (status != 1) {
      throw ErrorApiResponse(status: status, message: responseMap['message']);
    }

    return SuccessfulApiResponse(data: mapOrListToMap(responseMap['data']));
  }

  Future<Map<String, dynamic>> sendMap({
    required HttpMethod method,
    required String path,
    Map<String, String>? queryParameters,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) async {
    final headersWithContentType = Map<String, String>();
    headersWithContentType.addAll(headers);
    headersWithContentType['Content-Type'] = ContentType.json.toString();

    final bodyString = jsonEncode(body);
    final responseString = await sendString(
      method: method,
      path: path,
      queryParameters: queryParameters,
      headers: headersWithContentType,
      body: bodyString,
    );

    final map = jsonDecode(responseString);
    return map;
  }

  Future<String> sendString({
    required HttpMethod method,
    required String path,
    Map<String, String>? queryParameters,
    required Map<String, String> headers,
    String? body,
  }) async {
    final uri = _createUri(path: path, queryParameters: queryParameters);
    http.Response response;

    if (_deviceKey != null && !headers.containsKey(_authorizationHeader)) {
      headers = mapWithEntry(headers, _authorizationHeader, _getBearerAuthorizationHeaderValue(_deviceKey!));
    }

    switch (method) {
      case HttpMethod.get:
        response = await http.get(uri, headers: headers);
        break;
      case HttpMethod.post:
        response = await http.post(uri, headers: headers, body: body);
        break;
    }

    if (response.statusCode != 200) {
      throw HttpException(response.body, uri: uri);
    }

    return response.body;
  }

  Future<String> sendFile({
    required String path,
    Map<String, String>? queryParameters,
    required Uint8List bytes,
  }) async {
    final uri = _createUri(path: path, queryParameters: queryParameters);
    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: '1.jpeg',
      ),
    );
    request.headers[_authorizationHeader] = _getBearerAuthorizationHeaderValue(_deviceKey!);

    final response = await request.send();
    final str = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw HttpException(str, uri: uri);
    }

    return str;
  }

  Uri _createUri({
    required String path,
    Map<String, String>? queryParameters,
  }) {
    path = path.replaceFirst('{@lang}', _lang);
    return Uri.https(host, path, queryParameters);
  }

  String _getBearerAuthorizationHeaderValue(String token) {
    return 'Bearer ' + token;
  }
}

enum HttpMethod {
  get,
  post,
}

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

abstract class RequestBody extends JsonSerializable {
}

abstract class ApiResponse {
  final int status;

  ApiResponse({
    required this.status,
  });
}

class SuccessfulApiResponse<T> extends ApiResponse {
  final T data;

  SuccessfulApiResponse({
    required this.data,
  }) : super(status: 1);
}

class ErrorApiResponse extends ApiResponse {
  final String message;

  ErrorApiResponse({
    required int status,
    required this.message,
  }) : super(status: status);
}

// TODO: Extract classes below to separate files.
class RegisterDeviceRequest extends RequestBody {
  final AppInfo appInfo;
  final DeviceInfoForServer deviceInfo;

  RegisterDeviceRequest({
    required this.appInfo,
    required this.deviceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'appInfo': appInfo.toJson(),
      'deviceInfo': deviceInfo.toJson(),
    };
  }
}

class RegisterDeviceResponseData {
  final String key;

  RegisterDeviceResponseData._({
    required this.key,
  });

  factory RegisterDeviceResponseData.fromMap(Map<String, dynamic> map) {
    return RegisterDeviceResponseData._(key: map['key']);
  }
}

class MeResponseData {
  final String? deviceStatus;
  final User? user;
  final List<TeacherSubject> teacherSubjects;
  final List<EditableContact> contacts;
  final List<String> allowedCurs;
  final List<MoneyAccount> moneyAccounts;
  final int? lastSseId;
  final RealtimeCredentials? realtimeCredentials;
  final bool hasUnsortedMedia;

  MeResponseData._({
    required this.deviceStatus,
    required this.user,
    required this.teacherSubjects,
    required this.contacts,
    required this.allowedCurs,
    required this.moneyAccounts,
    required this.lastSseId,
    required this.realtimeCredentials,
    required this.hasUnsortedMedia,
  });

  factory MeResponseData.fromMap(Map<String, dynamic> map) {
    final userMap = map['user'];

    return MeResponseData._(
      deviceStatus:         map['deviceStatus'],
      user:                 userMap == null ? null : User.fromMap(userMap),
      teacherSubjects:      TeacherSubject.fromMaps(map['teacherSubjects']),
      contacts:             EditableContact.fromMaps(map['contacts']),
      allowedCurs:          map['allowedCurs'].cast<String>(),
      moneyAccounts:        MoneyAccount.fromMaps(map['moneyAccounts']),
      lastSseId:            map['lastSseId'],
      realtimeCredentials:  RealtimeCredentials.fromMapOrNull(map['realtimeCredentials']),
      hasUnsortedMedia:     map['hasUnsortedMedia'],
    );
  }
}

class RealtimeCredentials {
  /// One of predefined constants.
  final String providerName;

  /// To authenticate when connecting to the provider.
  final String providerToken;

  /// When authenticated with a provider, this used to access
  /// the user's private channel.
  final String crossDeviceToken;

  /// Must be secret to the provider so that messages are opaque to them.
  final Uint8List encryptionKey;

  RealtimeCredentials({
    required this.providerName,
    required this.providerToken,
    required this.crossDeviceToken,
    required this.encryptionKey,
  });

  factory RealtimeCredentials.fromMap(Map<String, dynamic> map) {
    return RealtimeCredentials(
      providerName:     map['providerName'],
      providerToken:    map['providerToken'],
      crossDeviceToken: map['crossDeviceToken'],
      encryptionKey:    base64Decode(map['encryptionKey']),
    );
  }

  static RealtimeCredentials? fromMapOrNull(Map<String, dynamic>? map) {
    return map == null ? null : RealtimeCredentials.fromMap(map);
  }

  String getChecksum() {
    return providerName + '_' + providerToken + '_' + crossDeviceToken;
  }
}

class SaveProfileRequest extends RequestBody {
  final String firstName;
  final String middleName;
  final String lastName;
  final String sex;
  final List<String> langs;
  final SaveLocationRequest? location;

  SaveProfileRequest({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.sex,
    required this.langs,
    required this.location,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'firstName':    firstName,
      'middleName':   middleName,
      'lastName':     lastName,
      'sex':          sex,
      'langs':        langs,
      'location':     location?.toJson(),
    };
  }
}

class SaveLocationRequest extends RequestBody {
  final String countryCode;
  final int? cityId;
  final String streetAddress;
  final String privacy;

  SaveLocationRequest({
    required this.countryCode,
    required this.cityId,
    required this.streetAddress,
    required this.privacy,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'cityId': cityId,
      'streetAddress': streetAddress,
      'privacy': privacy,
    };
  }
}

class SaveContactParamsRequest extends RequestBody {
  final int contactId;
  final bool downloadEnabled;
  final ContactParams params;

  SaveContactParamsRequest({
    required this.contactId,
    required this.downloadEnabled,
    required this.params,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'contactId':        contactId,
      'downloadEnabled':  downloadEnabled,
      'params':           params.toJson(),
    };
  }
}

class SaveConsultingProductRequest extends RequestBody {
  final int subjectId;
  final bool enabled;
  final String body;
  final List<SaveConsultingProductVariantRequest> productVariants;

  SaveConsultingProductRequest({
    required this.subjectId,
    required this.enabled,
    required this.body,
    required this.productVariants,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'enabled': enabled,
      'body': body,
      'productVariants': productVariants,
    };
  }
}

class SaveConsultingProductVariantRequest extends RequestBody {
  final String formatIntName;
  final bool enabled;
  final Map<String, double> price;

  SaveConsultingProductVariantRequest({
    required this.formatIntName,
    required this.enabled,
    required this.price,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'formatIntName': formatIntName,
      'enabled': enabled,
      'price': price,
    };
  }
}

class GetServerSentEventsResponse {
  final List<ServerSentEvent>? items;

  GetServerSentEventsResponse({
    required this.items,
  });

  factory GetServerSentEventsResponse.fromMap(Map<String, dynamic> map) {
    final itemMaps = map['items'];
    return GetServerSentEventsResponse(
      items: itemMaps == null ? null : ServerSentEvent.fromMaps(itemMaps),
    );
  }
}

class SendChatMessageRequest extends RequestBody {
  final int chatId;
  final int type;
  final String uuid;
  final MessageBody body;

  SendChatMessageRequest({
    required this.chatId,
    required this.type,
    required this.uuid,
    required this.body,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'type':   type,
      'uuid':   uuid,
      'body':   body,
    };
  }
}

class SendChatMessageResponse {
  final int?      messageId;
  final DateTime? dateTimeInsert;
  final int       chatId;

  SendChatMessageResponse({
    required this.messageId,
    required this.dateTimeInsert,
    required this.chatId,
  });

  factory SendChatMessageResponse.fromMap(Map<String, dynamic> map) {
    return SendChatMessageResponse(
      messageId:      map['messageId'],
      dateTimeInsert: DateTime.tryParse(map['dateTimeInsert'] ?? ''),
      chatId:         map['chatId'],
    );
  }
}

class MarkChatMessagesReadRequest extends RequestBody {
  final List<int> messageIds;

  MarkChatMessagesReadRequest({
    required this.messageIds,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'messageIds': messageIds,
    };
  }
}

class CreateCartAndOrderRequest extends RequestBody {
  final List<LineItem> lineItems;

  CreateCartAndOrderRequest({
    required this.lineItems,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'lineItems': lineItems,
    };
  }
}

class CreateCartAndOrderResponse {
  final int orderId;
  final int paymentStatus;
  final NetworkRequestInfo? payRequest;

  CreateCartAndOrderResponse({
    required this.orderId,
    required this.paymentStatus,
    required this.payRequest,
  });

  factory CreateCartAndOrderResponse.fromMap(Map<String, dynamic> map) {
    return CreateCartAndOrderResponse(
      orderId: map['orderId'],
      paymentStatus: map['paymentStatus'],
      payRequest: NetworkRequestInfo.fromMapOrNull(map['payRequest']),
    );
  }
}

class ReviewDeliveryRequest extends RequestBody {
  final int deliveryId;
  final String action;
  final DeliveryReviewBodyRequest? reviewBody;
  final DeliveryComplaintBodyRequest? complaintBody;

  ReviewDeliveryRequest({
    required this.deliveryId,
    required this.action,
    this.reviewBody,
    this.complaintBody,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'deliveryId': deliveryId,
      'action': action,
      'reviewBody': reviewBody,
      'complaintBody': complaintBody,
    };
  }
}

class DeliveryReviewBodyRequest extends RequestBody {
  final double rating;
  final String text;

  DeliveryReviewBodyRequest({
    required this.rating,
    required this.text,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'text': text,
    };
  }
}

class DeliveryComplaintBodyRequest extends RequestBody {
  final String text;
  final bool contactMe;

  DeliveryComplaintBodyRequest({
    required this.text,
    required this.contactMe,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'contactMe': contactMe,
    };
  }
}

class DeliveryRequest extends RequestBody {
  final int deliveryId;

  DeliveryRequest({
    required this.deliveryId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'deliveryId': deliveryId,
    };
  }
}

class GeoCodeRequest extends RequestBody {
  final String countryTitle;
  final String? cityTitle;
  final String? streetAddress;

  GeoCodeRequest({
    required this.countryTitle,
    required this.cityTitle,
    required this.streetAddress,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'countryTitle': countryTitle,
      'cityTitle': cityTitle,
      'streetAddress': streetAddress,
    };
  }
}

class GeoCodeResponse {
  final double latitude;
  final double longitude;

  GeoCodeResponse({
    required this.latitude,
    required this.longitude,
  });

  factory GeoCodeResponse.fromMap(Map<String, dynamic> map) {
    return GeoCodeResponse(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class CreateCommentRequest extends RequestBody {
  final String catalog;
  final int objectId;
  final String text;

  CreateCommentRequest({
    required this.catalog,
    required this.objectId,
    required this.text,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'catalog': catalog,
      'objectId': objectId,
      'text': text,
    };
  }
}

class CreateCommentResponse {
  final int commentId;

  CreateCommentResponse({
    required this.commentId,
  });

  factory CreateCommentResponse.fromMap(Map<String, dynamic> map) {
    return CreateCommentResponse(
      commentId: map['commentId'],
    );
  }
}

class DeleteCommentRequest extends RequestBody {
  final String catalog;
  final int commentId;

  DeleteCommentRequest({
    required this.catalog,
    required this.commentId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'catalog': catalog,
      'commentId': commentId,
    };
  }
}
