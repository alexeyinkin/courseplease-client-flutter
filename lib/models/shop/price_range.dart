class PriceRange {
  final String cur;
  final double from;
  final double? to;

  static const maxUsd = 200.0; // TODO: Remove when we query server for ranges.

  PriceRange({
    required this.cur,
    this.from = 0,
    this.to
  });

  Map<String, dynamic>? toJson() {
    if (!isLimited()) return null;

    return {
      'cur': cur,
      'from': from,
      'to': to,
    };
  }

  bool isLimited() {
    return from != 0 || to != null;
  }
}
