import 'dart:convert';

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
import 'screen_configuration.dart';

class AppState extends ChangeNotifier {
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

    if (event is PageStackScreenBlocEvent) {
      if (event.screenBlocEvent is ScreenBlocConfigurationChangedEvent) {
        notifyListeners();
      }
    }
  }

  PageStackBloc<ScreenConfiguration> getCurrentTabStackBloc() {
    switch (homeState.homeTab) {
      case HomeTab.explore:   return exploreTabBloc;
      case HomeTab.learn:     return learnTabBloc;
      case HomeTab.teach:     return teachTabBloc;
      case HomeTab.messages:  return messagesTabBloc;
      case HomeTab.profile:   return profileTabBloc;
    }
    throw UnimplementedError();
  }

  void pushPage(AbstractPage<ScreenConfiguration> page) {
    getCurrentTabStackBloc().push(page);
  }

  AppConfiguration get currentConfiguration {
    final currentScreenConfiguration = getCurrentTabStackBloc().topPageCurrentConfiguration;

    return AppConfiguration(
      screenConfiguration: currentScreenConfiguration,
      appNormalizedState: AppNormalizedState(
        appBlocNormalizedState: _appBloc.normalizedState,
        homeTab: homeState.homeTab,
      ),
      lang: langState.lang,
    );
  }

  Future<void> setConfiguration(AppConfiguration configuration) async {
    langState.setLang(configuration.lang);
    _appBloc.normalizedState = configuration.appNormalizedState.appBlocNormalizedState;
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
