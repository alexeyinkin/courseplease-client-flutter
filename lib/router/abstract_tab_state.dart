import 'package:flutter/widgets.dart';

class AbstractTabState extends ChangeNotifier {
  final _pages = <Page>[];
  List<Page> get pages => _pages;

  void pushPage(Page page) {
    _pages.add(page);
    notifyListeners();
  }

  bool popPage() {
    if (_pages.isEmpty) return false;
    _pages.removeLast();
    notifyListeners();
    return true;
  }
}
