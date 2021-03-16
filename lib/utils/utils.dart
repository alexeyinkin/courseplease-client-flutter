import 'dart:math';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

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

O whereId<I, O extends WithId<I>>(List<O> objects, I id) { // Return Nullable
  for (final object in objects) {
    if (object.id == id) {
      return object;
    }
  }
  return null;
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

List<T> fromMaps<T>(List list, T Function(Map<String, dynamic>) factory) {
  final castList = list.cast<Map<String, dynamic>>();
  final result = <T>[];

  for (final map in castList) {
    result.add(factory(map));
  }

  return result;
}

String enumValueAfterDot(value) {
  return value.toString().split('.').last;
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

String formatTimeOrDate(DateTime dt, Locale locale) {
  final now = DateTime.now();
  final localeString = locale.toString();
  DateFormat format;

  if (now.day == dt.day && now.month == dt.month && now.year == dt.year) {
    format = DateFormat.Hm(localeString);
  } else if (false) { // TODO: Calculate if yesterday.
    return tr('common.yesterday');
  } else if (now.year == dt.year) {
    format = DateFormat.MMMd(localeString);
  } else {
    format = DateFormat.yMMMd(localeString);
  }

  return format.format(dt);
}

String formatTime(DateTime dt, Locale locale) {
  final localeString = locale.toString();
  final format = DateFormat.Hm(localeString);
  return format.format(dt);
}

String formatShortRoughDuration(Duration duration) {
  if (duration.inSeconds < 60) {
    return tr('util.shortDuration.zero');
  }

  if (duration.inMinutes < 60) {
    return tr('util.shortDuration.m', namedArgs: {'n': duration.inMinutes.toString()});
  }

  if (duration.inHours < 24) {
    return tr('util.shortDuration.h', namedArgs: {'n': duration.inHours.toString()});
  }

  return tr('util.shortDuration.d', namedArgs: {'n': duration.inDays.toString()});
}

String formatLongRoughDurationAgo(Duration duration) {
  if (duration.inSeconds < 60) {
    return tr('util.longDurationAgo.zero');
  }

  if (duration.inMinutes < 60) {
    return plural('util.longDurationAgo.minutesAgo', duration.inMinutes);
  }

  if (duration.inHours < 24) {
    return plural('util.longDurationAgo.hoursAgo', duration.inHours);
  }

  return plural('util.longDurationAgo.daysAgo', duration.inDays);
}

String formatLongRoughDurationValidFor(Duration duration) {
  if (duration.inMinutes < 60) {
    return plural('util.longDurationValidFor.minutes', duration.inMinutes);
  }

  if (duration.inHours < 24) {
    return plural('util.longDurationValidFor.hours', duration.inHours);
  }

  return plural('util.longDurationValidFor.days', duration.inDays);
}

String formatMoneyValue(double value) {
  return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
}

/// Until we have a rich editor, text should be preprocessed before showing
/// in the input. Two line breaks in markdown are one visual line break.
String markdownToControllerText(String markdown) {
  return markdown.replaceAll('\n\n', '\n');
}

/// Until we have a rich editor, text should be preprocessed before sending
/// markdown to the backend. One visual line break is to line breaks in markdown.
String controllerTextToMarkdown(String controllerText) {
  return controllerText.replaceAll('\n', '\n\n');
}

Type typeOf<T>() => T;
