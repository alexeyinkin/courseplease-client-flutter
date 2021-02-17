import 'dart:convert';
import 'package:courseplease/services/net/api_client.dart';

abstract class AbstractFilter implements JsonSerializable {
  @override
  String toString() {
    return jsonEncode(this);
  }
}
