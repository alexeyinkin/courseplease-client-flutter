import 'dart:math';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';

import 'package:courseplease/models/interfaces.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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

Map<K, V> mapOrEmptyListToMap<K, V>(mapOrEmptyList) {
  return (mapOrEmptyList is List)
      ? Map<K, V>()  // Empty PHP array converted to array instead of map.
      : mapOrEmptyList.cast<K, V>();
}

O? whereId<I, O extends WithId<I>>(List<O> objects, I? id) {
  if (id == null) return null;

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

T enumValueByString<T>(List<T> values, String str, T defaultValue) {
  for (final value in values) {
    if (enumValueAfterDot(value) == str) return value;
  }
  return defaultValue;
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

String formatDateTime(DateTime dt, Locale locale) {
  return tr(
    'common.dateTime',
    namedArgs: {
      'date': formatDate(dt, locale),
      'time': formatTime(dt, locale),
    },
  );
}

String formatTimeOrDate(DateTime dt, Locale locale) {
  final now = DateTime.now();
  return areSameDay(now, dt)
      ? formatTime(dt, locale)
      : formatDate(dt, locale);
}

String formatTime(DateTime dt, Locale locale) {
  final localeString = locale.toString();

  // Would be better to use DateFormat.Hm as it is supposed to take care of RTL.
  // But it keeps a leading zero. TODO: Allow RTL without the leading zero.
  //final format = DateFormat.Hm(localeString);

  final format = DateFormat("H:mm");
  return format.format(dt);
}

String formatDate(DateTime dt, Locale locale) {
  switch (getDaysAfterNow(dt)) {
    case 1:  return tr('common.tomorrow');
    case 0:  return tr('common.today');
    case -1: return tr('common.yesterday');
  }

  final now = DateTime.now();
  final localeString = locale.toString();
  late final DateFormat format;

  if (now.year == dt.year) {
    format = DateFormat.MMMd(localeString);
  } else {
    format = DateFormat.yMMMd(localeString);
  }
  return format.format(dt);
}

int getDaysAfterNow(DateTime dt) {
  DateTime now = DateTime.now();
  return DateTime(dt.year, dt.month, dt.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}

String formatDetailedDate(DateTime dt, Locale locale) {
  final parts = <String>[];

  switch (getDaysAfterNow(dt)) {
    case 1:  parts.add(tr('common.tomorrow'));  break;
    case 0:  parts.add(tr('common.today'));     break;
    case -1: parts.add(tr('common.yesterday')); break;
  }

  final now = DateTime.now();
  final localeString = locale.toString();

  // TODO: Localize, https://api.flutter.dev/flutter/intl/DateFormat-class.html
  parts.add(DateFormat(DateFormat.ABBR_WEEKDAY).format(dt));

  late final DateFormat format;

  if (now.year == dt.year) {
    format = DateFormat.MMMd(localeString);
  } else {
    format = DateFormat.yMMMd(localeString);
  }
  parts.add(format.format(dt));

  return parts.join(', ');
}

String getTimeZoneString(DateTime dt) {
  final offset = dt.timeZoneOffset;
  final sign = offset.isNegative ? '−' : '+'; // Unicode minus.

  return dt.timeZoneName + ', GMT' + sign + offset.inHours.toString().padLeft(2, '0') + ':' + (offset.inMinutes % 60).toString().padLeft(2, '0');
}

bool areSameDay(DateTime one, DateTime two) {
  return one.day == two.day && one.month == two.month && one.year == two.year;
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

Locale requireLocale(BuildContext context) {
  final localization = EasyLocalization.of(context);
  if (localization == null) throw Exception('No locale');
  return localization.locale;
}

RelativeRect getContextRelativeRect(BuildContext context) {
  final renderObject = context.findRenderObject();

  if (renderObject == null) {
    throw Exception('context.findRenderObject() returned null');
  }

  final translation = renderObject.getTransformTo(null).getTranslation();
  final rect = renderObject.paintBounds.shift(Offset(translation.x, translation.y));
  final screenSize = MediaQuery
      .of(context)
      .size;

  return RelativeRect.fromLTRB(
    rect.left,
    rect.top,
    screenSize.width - rect.left - rect.width,
    screenSize.height - rect.top - rect.height,
  );
}

List<I> idsList<I>(List<WithId<I>> objects) {
  final result = <I>[];

  for (final object in objects) {
    result.add(object.id);
  }

  return result;
}

List<String> dateTimesToStrings(List<DateTime> dateTimes) {
  final result = <String>[];

  for (final dt in dateTimes) {
    result.add(dt.toUtc().toIso8601String());
  }

  return result;
}

List<DateTime> stringsToDateTimes(List<String> strings) {
  final result = <DateTime>[];

  for (final str in strings) {
    final parsed = DateTime.tryParse(str);

    if (parsed == null) {
      print('Failed to parse DateTime: ' + str);
      continue;
    }

    result.add(parsed);
  }

  return result;
}

List<List<DateTime>> groupByDates(List<DateTime> dateTimes) {
  final result = <List<DateTime>>[];
  var year = 0;
  var month = 0;
  var day = 0;
  List<DateTime> currentGroup = <DateTime>[];

  for (final dt in dateTimes) {
    if (dt.year == year && dt.month == month && dt.day == day) {
      currentGroup.add(dt);
      continue;
    }

    currentGroup = [dt];
    result.add(currentGroup);
    year = dt.year;
    month = dt.month;
    day = dt.day;
  }

  return result;
}

List<DateTime> dateTimesToLocal(List<DateTime> dateTimes) {
  final result = <DateTime>[];

  for (final dt in dateTimes) {
    result.add(dt.toLocal());
  }

  return result;
}

String shortenIfLonger(String str, int length) {
  return str.length < length
      ? str
      : str.substring(0, length);
}

List<I> getIds<I>(List<WithId<I>> objects) {
  final ids = <I>[];

  for (final obj in objects) {
    ids.add(obj.id);
  }

  return ids;
}

List<T> notNulls<T>(List<T?> list) {
  final result = <T>[];

  for (final item in list) {
    if (item != null) result.add(item);
  }

  return result;
}

Map<String, dynamic> mapOrListToMap(mapOrList) {
  if (mapOrList is Map) {
    return mapOrList.cast<String, dynamic>();
  }

  if (mapOrList is List) {
    return <String, dynamic>{};
  }

  throw Exception('Expected map or list, given: ' + mapOrList.runtimeType.toString());
}

void showDialogWhile(
  Future Function() dialogCreator,
  Future future,
) {
  var shown = true;

  final dialogFuture = dialogCreator();

  dialogFuture.whenComplete(() { shown = false; });

  future.whenComplete(() {
    if (shown) {
      navigatorKey.currentState?.pop();
    }
  });
}

bool isInPast(DateTime dt) => dt.isBefore(DateTime.now());
bool isInFuture(DateTime dt) => dt.isAfter(DateTime.now());

Type typeOf<T>() => T;
