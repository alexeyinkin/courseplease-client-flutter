import 'package:courseplease/models/interfaces.dart';

class Sorters {
  static int titleAsc(WithTitle a, WithTitle b) {
    return a.title.compareTo(b.title);
  }
}
