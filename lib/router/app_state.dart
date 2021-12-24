import 'package:courseplease/models/product_subject.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'abstract_tab_state.dart';
import 'explore_tab_state.dart';
import 'home_state.dart';
import 'lang_state.dart';

class AppState extends ChangeNotifier {
  final langState = LangState();
  final homeState = HomeState();

  final exploreTabState = ExploreTabState();
  final learnTabState = AbstractTabState();
  final teachTabState = AbstractTabState();
  final messagesTabState = AbstractTabState();
  final profileTabState = AbstractTabState();

  static Future<AppState> create() async {
    final appState = AppState();
    await appState._init();
    return appState;
  }

  Future<void> _init() async {
    await langState.init();
  }

  AppState() {
    langState.addListener(notifyListeners);
    homeState.addListener(notifyListeners);

    exploreTabState.addListener(notifyListeners);
    learnTabState.addListener(notifyListeners);
    teachTabState.addListener(notifyListeners);
    messagesTabState.addListener(notifyListeners);
    profileTabState.addListener(notifyListeners);
  }

  AbstractTabState getCurrentTabState() {
    switch (homeState.homeTab) {
      case HomeTab.explore:   return exploreTabState;
      case HomeTab.learn:     return learnTabState;
      case HomeTab.teach:     return teachTabState;
      case HomeTab.messages:  return messagesTabState;
      case HomeTab.profile:   return profileTabState;
    }
    throw UnimplementedError();
  }

  @override
  void dispose() {
    langState.dispose();
    homeState.dispose();
    exploreTabState.dispose();
    super.dispose();
  }
}


// TODO: Extract somewhere.

class AppRoutePath {
  final String lang;

  AppRoutePath({
    required this.lang,
  });
}

class ExploreRoutePath extends AppRoutePath {
  ExploreRoutePath({
    required String lang,
  }) : super(
    lang: lang,
  );
}

class ExploreSubjectRoutePath extends AppRoutePath {
  final ProductSubject productSubject;
  final ExploreTab tab;

  ExploreSubjectRoutePath({
    required String lang,
    required this.productSubject,
    required this.tab,
  }) : super(
    lang: lang,
  );
}

class LearnRoutePath extends AppRoutePath {
  LearnRoutePath({
    required String lang,
  }) : super(
    lang: lang,
  );
}

class TeachRoutePath extends AppRoutePath {
  TeachRoutePath({
    required String lang,
  }) : super(
    lang: lang,
  );
}

class MessagesRoutePath extends AppRoutePath {
  MessagesRoutePath({
    required String lang,
  }) : super(
    lang: lang,
  );
}

class MeRoutePath extends AppRoutePath {
  MeRoutePath({
    required String lang,
  }) : super(
    lang: lang,
  );
}
