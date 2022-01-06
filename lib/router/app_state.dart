import 'package:app_state/app_state.dart';
import 'package:courseplease/screens/explore/page.dart';
import 'package:courseplease/screens/my_profile/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'app_configuration.dart';
import 'home_state.dart';
import 'lang_state.dart';

class AppState extends ChangeNotifier {
  final langState = LangState();
  final homeState = HomeState();

  final exploreTabBloc = PageStackBloc(bottomPage: ExplorePage());
  final learnTabBloc = PageStackBloc(bottomPage: ExplorePage());
  final teachTabBloc = PageStackBloc(bottomPage: ExplorePage());
  final messagesTabBloc = PageStackBloc(bottomPage: ExplorePage());
  final profileTabBloc = PageStackBloc(bottomPage: MyProfilePage());

  final _eventsController = BehaviorSubject<PageStackBlocEvent>();
  Stream<PageStackBlocEvent> get events => _eventsController.stream;

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

    exploreTabBloc.events.listen(_onPageStackEvent);
    learnTabBloc.events.listen(_onPageStackEvent);
    teachTabBloc.events.listen(_onPageStackEvent);
    messagesTabBloc.events.listen(_onPageStackEvent);
    profileTabBloc.events.listen(_onPageStackEvent);
  }

  void _onPageStackEvent(PageStackBlocEvent event) {
    _eventsController.sink.add(event);

    if (event is PageStackScreenBlocEvent) {
      if (event.screenBlocEvent is ScreenBlocConfigurationChangedEvent) {
        notifyListeners();
      }
    }
  }

  PageStackBloc getCurrentTabStackBloc() {
    switch (homeState.homeTab) {
      case HomeTab.explore:   return exploreTabBloc;
      case HomeTab.learn:     return learnTabBloc;
      case HomeTab.teach:     return teachTabBloc;
      case HomeTab.messages:  return messagesTabBloc;
      case HomeTab.profile:   return profileTabBloc;
    }
    throw UnimplementedError();
  }

  void pushPage(AbstractPage<AppConfiguration> page) {
    getCurrentTabStackBloc().pushPage(page);
  }

  @override
  void dispose() {
    langState.dispose();
    homeState.dispose();

    exploreTabBloc.dispose();
    learnTabBloc.dispose();
    teachTabBloc.dispose();
    messagesTabBloc.dispose();
    profileTabBloc.dispose();

    _eventsController.close();

    super.dispose();
  }
}
