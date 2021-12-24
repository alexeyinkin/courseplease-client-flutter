import 'package:courseplease/router/intl_provider.dart';
import 'package:courseplease/router/secure_storage_keys_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

class LangState extends ChangeNotifier {
  final _secureStorage = GetIt.instance.get<FlutterSecureStorage>();

  String _lang = 'fr';
  bool _isSetExplicitly = false;
  bool get isSetExplicitly => _isSetExplicitly;

  Future<void> init() async {
    _lang = null
        ?? await _getLangFromStorage()
        ?? await _getDeviceLang()
    ;

    await _writeKey();
  }

  Future<String?> _getLangFromStorage() async {
    return _secureStorage.read(key: SecureStorageKeysEnum.lang);
  }

  Future<String> _getDeviceLang() async {
    final locale = await getDeviceLocale();
    return locale.languageCode;
  }

  Future<void> setLang(String lang) async {
    if (lang == _lang) {
      if (!_isSetExplicitly) {
        _isSetExplicitly = true;
        notifyListeners();
      }
      return;
    }

    _lang = lang;
    _isSetExplicitly = true;
    await _writeKey();
    notifyListeners();
  }

  String get lang => _lang;

  Future<void> _writeKey() {
    print('LANG Writing ' + _lang);
    return _secureStorage.write(key: SecureStorageKeysEnum.lang, value: _lang);
  }
}
