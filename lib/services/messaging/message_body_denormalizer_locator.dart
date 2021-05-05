import 'package:courseplease/services/messaging/abstract.dart';
import 'package:courseplease/services/messaging/unknown_denormalizer.dart';

class MessageBodyDenormalizerLocator {
  final _denormalizersByType = <int, AbstractMessageBodyDenormalizer>{};
  final _defaultDenormalizer = UnknownMessageBodyDenormalizer();

  void add(int type, AbstractMessageBodyDenormalizer listener) {
    _denormalizersByType[type] = listener;
  }

  AbstractMessageBodyDenormalizer get(int type) {
    return _denormalizersByType[type] ?? _defaultDenormalizer;
  }
}
