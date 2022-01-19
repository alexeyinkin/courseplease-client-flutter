import 'package:app_state/app_state.dart';
import 'package:courseplease/router/page_factory.dart';
import 'package:courseplease/screens/explore/page.dart';
import 'package:courseplease/screens/learn/page.dart';
import 'package:courseplease/screens/messages/page.dart';
import 'package:courseplease/screens/my_profile/page.dart';
import 'package:courseplease/screens/teach/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'app_configuration.dart';
import 'home_state.dart';
import 'lang_state.dart';
import 'page_configuration.dart';

class AppState extends ChangeNotifier {
  bool _setExplicitly = false;
  final _appBloc = AppBloc();
  final langState = LangState();
  final homeState = HomeState();

  final exploreTabBloc = PageStackBloc(bottomPage: ExplorePage(), createPage: PageFactory.createPage);
  final learnTabBloc = PageStackBloc(bottomPage: const LearnPage(), createPage: PageFactory.createPage);
  final teachTabBloc = PageStackBloc(bottomPage: const TeachPage(), createPage: PageFactory.createPage);
  final messagesTabBloc = PageStackBloc(bottomPage: const MessagesPage(), createPage: PageFactory.createPage);
  final profileTabBloc = PageStackBloc(bottomPage: MyProfilePage(), createPage: PageFactory.createPage);

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
    _appBloc.addPageStack('explore', exploreTabBloc);
    _appBloc.addPageStack('learn', learnTabBloc);
    _appBloc.addPageStack('teach', teachTabBloc);
    _appBloc.addPageStack('messages', messagesTabBloc);
    _appBloc.addPageStack('profile', profileTabBloc);

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

    if (event is PageStackPageBlocEvent) {
      if (event.pageBlocEvent is PageBlocConfigurationChangedEvent) {
        notifyListeners();
      }
    }
  }

  PageStackBloc<MyPageConfiguration> getCurrentTabStackBloc() {
    switch (homeState.homeTab) {
      case HomeTab.explore:   return exploreTabBloc;
      case HomeTab.learn:     return learnTabBloc;
      case HomeTab.teach:     return teachTabBloc;
      case HomeTab.messages:  return messagesTabBloc;
      case HomeTab.profile:   return profileTabBloc;
    }
    throw UnimplementedError();
  }

  void pushPage(AbstractPage<MyPageConfiguration> page, {
    DuplicatePageKeyAction? onDuplicateKey,
  }) {
    getCurrentTabStackBloc().push(page, onDuplicateKey: onDuplicateKey);
  }

  MyAppConfiguration? getConfiguration() {
    if (!_setExplicitly) {
      // The initial URL parsing is awaiting, but we are already asked for
      // the configuration. Even though we have a potentially usable default
      // state, returning it would add a record to browser history.
      // So only return a configuration after initialized from the initial URL.
      return null;
    }

    final topPageConfiguration = getCurrentTabStackBloc().getTopPageConfiguration();

    return MyAppConfiguration(
      topPageConfiguration: topPageConfiguration,
      appNormalizedState: AppNormalizedState(
        appConfiguration: _appBloc.getConfiguration(),
        homeTab: homeState.homeTab,
      ),
      lang: langState.lang,
    );
  }

  Future<void> setConfiguration(MyAppConfiguration configuration) async {
    langState.setLang(configuration.lang, fire: false);
    homeState.setHomeTab(configuration.appNormalizedState.homeTab, fire: false);

    _appBloc.setConfiguration(
      configuration.appNormalizedState.appConfiguration,
      fire: false,
    );

    _setExplicitly = true;
    notifyListeners();
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
