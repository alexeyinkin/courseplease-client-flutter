import 'package:flutter/widgets.dart';

enum HomeTab {
  explore,
  learn,
  teach,
  messages,
  profile,
}

class HomeState extends ChangeNotifier {
  HomeTab _homeTab = HomeTab.explore;

  set homeTab(HomeTab tab) {
    if (tab == _homeTab) return;
    _homeTab = tab;
    notifyListeners();
  }
  HomeTab get homeTab => _homeTab;
}
