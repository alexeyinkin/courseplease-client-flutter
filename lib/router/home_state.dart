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

  void setHomeTab(HomeTab tab, {bool fire = true}) {
    if (tab == _homeTab) return;
    _homeTab = tab;

    if (fire) notifyListeners();
  }

  HomeTab get homeTab => _homeTab;
}
