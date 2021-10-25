import 'package:model_interfaces/model_interfaces.dart';

class Language implements WithIdTitle<String> {
  final String id;
  final String title;

  Language({
    required this.id,
    required this.title,
  });
}
