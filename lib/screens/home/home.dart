import 'package:courseplease/router/app_state.dart';
import 'package:courseplease/router/home_state.dart';
import 'package:courseplease/screens/home/local_widgets/explore_tab_navigator.dart';
import 'package:courseplease/screens/home/local_widgets/profile_tab_navigator.dart';
import 'package:courseplease/screens/home/local_widgets/teaching_tab.dart';
import 'package:courseplease/widgets/messages_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:courseplease/screens/home/local_widgets/messages_tab.dart';
import 'package:get_it/get_it.dart';
import 'package:keyed_collection_widgets/keyed_collection_widgets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'local_widgets/learning_tab.dart';

class HomeScreen extends StatefulWidget {
  final HomeTab currentTab;

  HomeScreen({
    required this.currentTab,
  });

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _appState = GetIt.instance.get<AppState>();
  //final _pollEventsButtonIndex = 5;
  final _pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    print('Building HomeScreen ' + (DateTime.now().millisecondsSinceEpoch % 1000).toString() + ' ' + _appState.homeState.homeTab.toString());

    return Scaffold(
      body: PageStorage(
        bucket: _pageStorageBucket,
        child: KeyedStack<HomeTab>(
          children: {
            HomeTab.explore:  ExploreTabNavigator(state: _appState.exploreTabState),
            HomeTab.learn:    LearningTabWidget(),
            HomeTab.teach:    TeachingTabWidget(),
            HomeTab.messages: MessagesTab(),
            HomeTab.profile:  ProfileTabNavigator(state: _appState.profileTabState),
          },
          itemKey: widget.currentTab,
        ),
      ),
      bottomNavigationBar: KeyedBottomNavigationBar<HomeTab>(
        currentItemKey: widget.currentTab,
        type: BottomNavigationBarType.fixed,
        onTap: (t) => _appState.homeState.homeTab = t,
        unselectedItemColor: Theme.of(context).textTheme.caption!.color,
        items: {
          HomeTab.explore: BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: tr('ExploreTabWidget.iconTitle'),
          ),
          HomeTab.learn: BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: tr('LearningTabWidget.iconTitle'),
          ),
          HomeTab.teach: BottomNavigationBarItem(
            icon: Icon(MdiIcons.teach),
            label: tr('TeachingTabWidget.iconTitle'),
          ),
          HomeTab.messages: BottomNavigationBarItem(
            icon: MessagesIconWidget(),
            label: tr('MessagesTabWidget.iconTitle'),
          ),
          HomeTab.profile: BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: tr('MyProfileTabWidget.iconTitle'),
          ),
          // // TODO: Remove this debugging button:
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.sync),
          //   label: "Poll Events",
          // ),
        },
      ),
    );
  }

  // void _onTabTap(int index) {
  //   if (index == _pollEventsButtonIndex) {
  //     _pollEvents();
  //     return;
  //   }
  //
  //   _homeScreenCubit.setCurrentTabIndex(index);
  // }
  //
  // void _pollEvents() {
  //   final cubit = GetIt.instance.get<ServerSentEventsCubit>();
  //   cubit.poll();
  // }
}
