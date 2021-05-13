class TimeSlot {
  final DateTime dateTime;
  final bool enabled;

  TimeSlot({
    required this.dateTime,
    required this.enabled,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      dateTime: DateTime.parse(map['dateTime']),
      enabled: map['enabled'],
    );
  }

  static List<TimeSlot> fromMaps(List maps) {
    return maps
        .cast<Map<String, dynamic>>()
        .map((map) => TimeSlot.fromMap(map))
        .toList()
        .cast<TimeSlot>();
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toUtc().toIso8601String(),
      'enabled': enabled,
    };
  }

  static List<Map<String, dynamic>> toMaps(List<TimeSlot> list) {
    return list
        .map((obj) => obj.toJson())
        .toList()
        .cast<Map<String, dynamic>>();
  }

  static List<List<TimeSlot>> groupByLocalDates(List<TimeSlot> slots) {
    final result = <List<TimeSlot>>[];
    var year = 0;
    var month = 0;
    var day = 0;
    List<TimeSlot> currentGroup = <TimeSlot>[];

    for (final slot in slots) {
      final dt = slot.dateTime.toLocal();
      if (dt.year == year && dt.month == month && dt.day == day) {
        currentGroup.add(slot);
        continue;
      }

      currentGroup = [slot];
      result.add(currentGroup);
      year = dt.year;
      month = dt.month;
      day = dt.day;
    }

    return result;
  }
}
