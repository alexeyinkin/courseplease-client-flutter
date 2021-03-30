import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/block/aes_fast.dart';
import 'package:pointycastle/block/modes/cbc.dart';
import 'package:pointycastle/padded_block_cipher/padded_block_cipher_impl.dart';
import 'package:pointycastle/paddings/pkcs7.dart';

Uint8List decryptAes256Cbc(Uint8List encrypted, Uint8List key, Uint8List iv) {
  // From https://stackoverflow.com/a/64064546/11382675
  final cipher = CBCBlockCipher(AESFastEngine());
  final params = ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
  final paddingParams = PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(params, null);

  final paddingCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
  paddingCipher.init(false, paddingParams);

  final decryptedBytes = paddingCipher.process(encrypted);

  return decryptedBytes;
}
