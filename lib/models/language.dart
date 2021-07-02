import 'interfaces.dart';

class Language extends WithIdTitle<String> {
  final String id;
  final String title;

  Language({
    required this.id,
    required this.title,
  });
}
