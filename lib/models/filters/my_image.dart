import 'abstract.dart';

class MyImageFilter extends AbstractFilter {
  final List<int> albumIds;
  final List<int> contactIds;
  final List<int> purposeIds;
  final List<int> subjectIds;
  final bool unsorted;

  MyImageFilter({
    this.albumIds = const <int>[],
    this.contactIds = const <int>[],
    this.purposeIds = const <int>[],
    this.subjectIds = const <int>[],
    this.unsorted = false,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'albumIds':   albumIds,
      'contactIds': contactIds,
      'purposeIds': purposeIds,
      'subjectIds': subjectIds,
      'unsorted':   unsorted,
    };
  }
}
