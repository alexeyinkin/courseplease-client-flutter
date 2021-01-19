import 'dart:math';

import 'package:courseplease/models/interfaces.dart';

enum RequestStatus {
  notTried,
  loading,
  ok,
  error,
}


String formatDuration(Duration duration) {
  final seconds = duration.inSeconds % 60;
  final minutes = duration.inMinutes % 60;
  final hours = duration.inHours;
  final parts = <String>[];

  if (hours > 0) parts.add(hours.toString());

  parts.add(minutes.toString().padLeft(hours > 0 ? 2 : 1, '0'));
  parts.add(seconds.toString().padLeft(2, '0'));

  return parts.join(':');
}

Map<String, String> toStringStringMap(mapOrEmptyList) {
  return (mapOrEmptyList is List)
      ? Map<String, String>()  // Empty PHP array converted to array instead of map.
      : mapOrEmptyList.cast<String, String>();
}

List<O> whereIds<I, O extends WithId<I>>(List<O> objects, List<I> ids) {
  final idsMap = ids.asMap();
  final result = <O>[];

  for (final object in objects) {
    if (idsMap.containsKey(object.id)) {
      result.add(object);
    }
  }

  return result;
}

Map<K, V> whereKeys<K, V>(Map<K, V> map, List<K> keys) {
  final result = Map<K, V>();

  for (final key in keys) {
    result[key] = map[key];
  }

  return result;
}

Map<K, V> mapWithEntry<K, V>(Map<K, V> map, K key, V value) {
  final mapClone = Map<K, V>.from(map);
  mapClone[key] = value;
  return mapClone;
}

String generatePassword(int length) {
  final generator = Random.secure();
  final chars = '23456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ~!@#\$%^&*()-_=+';
  final charCount = chars.length;
  String result = '';

  while (--length >= 0) {
    result += chars[generator.nextInt(charCount)];
  }

  return result;
}
